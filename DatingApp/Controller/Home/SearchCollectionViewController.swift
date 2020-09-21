//
//  SearchCollectionViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import EmptyDataSet_Swift
import CoreLocation
import Geofirestore

class SearchCollectionViewController: UIViewController {
    
    // MARK:  - Properties
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var loginBunusView: UIView!
    @IBOutlet weak var backView: UIView!
    
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let manager = CLLocationManager()
    private var userLat = ""
    private var userLong = ""
    private let geofirestroe = GeoFirestore(collectionRef: COLLECTION_GEO)
    private var myQuery: GFSQuery!
    private var distance: Double = 500
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: RCOMPLETION)
        Messaging.messaging().unsubscribe(fromTopic: "message\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "like\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "type\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "match\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "gift\(Auth.auth().currentUser!.uid)")
        
//          setupBanner()
        testBanner()
        fetchUser()
        checkOneDayAndBadge()
        confifureLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        UserDefaults.standard.removeObject(forKey: CARDVC)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        collectionView.reloadData()
        if !Auth.auth().currentUser!.uid.isEmpty {
            if UserDefaults.standard.object(forKey: LIKE_ON) != nil {
                Messaging.messaging().subscribe(toTopic: "like\(Auth.auth().currentUser!.uid)")
            }
            if UserDefaults.standard.object(forKey: TYPE_ON) != nil {
                Messaging.messaging().subscribe(toTopic: "type\(Auth.auth().currentUser!.uid)")
            }
            if UserDefaults.standard.object(forKey: MESSAGE_ON) != nil {
                Messaging.messaging().subscribe(toTopic: "message\(Auth.auth().currentUser!.uid)")
            }
            if UserDefaults.standard.object(forKey: MATCH_ON) != nil {
                Messaging.messaging().subscribe(toTopic: "match\(Auth.auth().currentUser!.uid)")
            }
            if UserDefaults.standard.object(forKey: GIFT_ON) != nil {
                Messaging.messaging().subscribe(toTopic: "gift\(Auth.auth().currentUser!.uid)")
            }
        }
        
        if UserDefaults.standard.object(forKey: REFRESH) != nil {
            fetchUsers(user)
            UserDefaults.standard.removeObject(forKey: REFRESH)
        }
    }
    
    // MARK: - Actions
    
    @objc func handleDismissal() {
        removeEffectView()
    }
    
    @objc func refreshCollectionView(){
        UserDefaults.standard.set(true, forKey: REFRESH_ON)
        fetchUsers(user)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        guard Auth.auth().currentUser != nil else { return }

        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user

            if self.user.selectGender == "男性" {
                UserDefaults.standard.set(true, forKey: MALE)
            } else {
                UserDefaults.standard.removeObject(forKey: MALE)
            }
            if self.user.gender == "女性" {
                UserDefaults.standard.set(true, forKey: FEMALE)
            } else {
                UserDefaults.standard.removeObject(forKey: FEMALE)
            }
            
            self.fetchUsers(self.user)
            self.collectionView.reloadData()
        }
    }
    
    private func fetchUsers(_ user: User) {
        if UserDefaults.standard.object(forKey: REFRESH_ON) == nil {
            indicator.startAnimating()
        }
        
        let residence = user.residenceSerch
        if residence == "こだわらない" {
            User.fetchNationwide(user) { (users) in
                self.users = users
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
                self.refresh.endRefreshing()
                UserDefaults.standard.removeObject(forKey: REFRESH_ON)
            }
        } else {
            User.fetchUserResidenceSort(user) { (users) in
                self.users = users
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
                self.refresh.endRefreshing()
                UserDefaults.standard.removeObject(forKey: REFRESH_ON)
            }
        }
    }
    
    private func checkOneDayAndBadge() {
        guard Auth.auth().currentUser != nil else { return }

        User.fetchUserAddSnapshotListener() { (user) in
            self.user = user
            self.fetchUsers(self.user)
            
            if self.user.messageBadgeCount == 0 {
                
                if user.newMessage == false {
                    self.tabBarController?.viewControllers?[3].tabBarItem.badgeValue = nil
                }
            } else {
                self.tabBarController?.viewControllers?[3].tabBarItem?.badgeValue = String(self.user.messageBadgeCount)
            }
            
            if self.user.myPageBadgeCount == 0 {
                if user.newLike == false && user.newType == false {
                    self.tabBarController?.viewControllers?[4].tabBarItem.badgeValue = nil
                }
            } else {
                self.tabBarController?.viewControllers?[4].tabBarItem?.badgeValue = String(self.user.myPageBadgeCount)
            }
            
            if self.user.oneDay == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    updateUser(withValue: [POINTS: self.user.points + 1, ONEDAY: false, DAY: self.user.day + 0.5])
                    self.showLoginBunusView()
                    if self.user.day >= 14 {
                        updateUser(withValue: [NEWUSER: false])
                    }
                }
            }
        }
    }
    
    // MARK: - Heplers
    
    //    private func findUser() {
    //
    //        guard let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
    //            let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String else { return }
    //
    //        let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
    //
    //        myQuery = geofirestroe.query(withCenter: location, radius: distance)
    //        myQuery.observe(.documentEntered) { (key, location) in
    //
    //            if key != User.currentUserId() {
    //                User.fetchUser(key!) { (user) in
    //
    //                }
    //            }
    //        }
    //    }
    
    private func confifureLocationManager() {
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    private func showLoginBunusView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        backView.addGestureRecognizer(tap)
        loginBunusView.addGestureRecognizer(tap)
       
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
   
            self.loginBunusView.alpha = 1
            self.backView.alpha = 0.9
            
        }, completion: nil)
    }
    
    private func removeEffectView() {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.loginBunusView.alpha = 0
            self.backView.alpha = 0
        })
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func testBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func configure() {
        
        loginBunusView.alpha = 0
        backView.alpha = 0
        loginBunusView.layer.cornerRadius = 15
        collectionView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
}

//MARK: CollectionView

extension SearchCollectionViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            return UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        }
        return UIEdgeInsets(top: 30, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            return 10
        }
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            return users.count == 0 ? 0 : users.count
        }
        return users.count == 0 ? 0 : 1 + users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) == nil && indexPath.row == 0 || indexPath.row == 19 || indexPath.row == 38 || indexPath.row == 57 || indexPath.row == 76 || indexPath.row == 95 || indexPath.row == 114 || indexPath.row == 133 {
            
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! SearchCollectionViewCell
//            cell3.bannerView.adUnitID = "ca-app-pub-4750883229624981/8611268051"
//            cell3.bannerView.rootViewController = self
//            cell3.bannerView.load(GADRequest())
//            cell3.testBanner1()
            cell3.searchCVC = self
            
            return cell3
        }
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! SearchCollectionViewCell
            
            cell2.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            cell2.layer.shadowColor = UIColor.black.cgColor
            cell2.layer.shadowOpacity = 0.3
            cell2.layer.shadowRadius = 4
            cell2.layer.masksToBounds = false
            if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
                cell2.configureMiniCell(users[indexPath.row])
                return cell2
            }
            cell2.configureMiniCell(users[indexPath.row - 1])
            return cell2
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        cell.configureCell(users[indexPath.row - 1])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row].uid)
            return
        }
        if indexPath.row != 0 {
            performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row - 1].uid)
        }
    }
}

extension SearchCollectionViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return NSAttributedString(string: "ユーザーは見つかりませんでした", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "しばらくお待ちになるか、\n検索条件を変更してみてください")
    }
}

extension SearchCollectionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error location: \(error.localizedDescription) ")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        let updateLocation: CLLocation = locations.first!
        let newCordinate: CLLocationCoordinate2D = updateLocation.coordinate
        
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set("\(newCordinate.latitude)", forKey: "current_location_latitude")
        userDefaults.set("\(newCordinate.longitude)", forKey: "current_location_longitude")
        userDefaults.synchronize()
        
        print(newCordinate.latitude)
        print(newCordinate.longitude)
        
        if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
            let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String {
            
            updateUser(withValue: [LATITUDE: userLat, LONGITUDE: userLong])
            
            let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
            self.geofirestroe.setLocation(location: location, forDocumentWithID: User.currentUserId()) { (error) in
                if error == nil {
                    //                    self.findUser()
                }
            }
        }
    }
}
