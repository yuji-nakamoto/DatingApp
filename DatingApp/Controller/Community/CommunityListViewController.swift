//
//  CommunityListViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/19.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import GoogleMobileAds
import NVActivityIndicatorView

class CommunityListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var communityArray = [Community]()
    private var activityIndicator: NVActivityIndicatorView?
    lazy var searchBar: UISearchBar = UISearchBar(frame: navigationController!.navigationBar.bounds)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
//        testBanner()
        
        setupIndicator()
        setSearchBar()
        fetchCommunities()
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: C_NUMBER_ON)
        UserDefaults.standard.removeObject(forKey: C_CREATED_ON)
        UserDefaults.standard.removeObject(forKey: C_RECOMMENDED_ON)
        UserDefaults.standard.removeObject(forKey: C_SEARCH_ON)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchNumberCommunity() {
        
        showLoadingIndicator()
        communityArray.removeAll()
        Community.fetchNumberCommunity { (community) in
            self.communityArray = community
            self.collectionView.reloadData()
            self.hideLoadingIndicator()
        }
    }
    
    private func fetchCreatedCommunity() {
        
        showLoadingIndicator()
        communityArray.removeAll()
        Community.fetchCreatedCommunity { (community) in
            self.communityArray = community
            self.collectionView.reloadData()
            self.hideLoadingIndicator()
        }
    }
    
    private func fetchRecommendedCommunity() {
        
        showLoadingIndicator()
        communityArray.removeAll()
        Community.fetchRecommendedCommunity { (community) in
            self.communityArray = community
            self.communityArray.shuffle()
            self.collectionView.reloadData()
            self.hideLoadingIndicator()
        }
    }
    
    private func searchCommunity() {
        
        showLoadingIndicator()
        communityArray.removeAll()
        Community.communitySearch(text: searchBar.text!) { (community) in
            self.communityArray = community
            self.collectionView.reloadData()
            self.hideLoadingIndicator()
        }
    }
    
    // MARK: - Helpers
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    private func setupIndicator() {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15 , y: self.view.frame.height / 2 - 250, width: 25, height: 25), type: .circleStrokeSpin, color: UIColor(named: O_BLACK), padding: nil)
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
    
    private func setSearchBar() {
        
        if UserDefaults.standard.object(forKey: C_SEARCH_ON) != nil {
            searchBar.delegate = self
            searchBar.placeholder = "コミュニティを検索"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            
            if UserDefaults.standard.object(forKey: C_SEARCH_ON) != nil {
                searchBar.becomeFirstResponder()
            }
        }
    }
    
    private func fetchCommunities() {
        
        if UserDefaults.standard.object(forKey: C_NUMBER_ON) != nil {
            fetchNumberCommunity()
            navigationItem.title = "人気"
        } else if UserDefaults.standard.object(forKey: C_CREATED_ON) != nil {
            fetchCreatedCommunity()
            navigationItem.title = "新規"
        } else if UserDefaults.standard.object(forKey: C_RECOMMENDED_ON) != nil {
            fetchRecommendedCommunity()
            navigationItem.title = "おすすめ"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CommunityUsersVC" {
            let communityUsersVC = segue.destination as! CommunityUsersViewController
            let communityId = sender as! String
            communityUsersVC.communityId = communityId
        }
    }
}

//MARK: CollectionView

extension CommunityListViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  communityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CommunityTableViewCell
        cell.configureCell(communityArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CommunityUsersVC", sender: communityArray[indexPath.row].communityId)
    }
}

extension CommunityListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchCommunity()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCommunity()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.text = ""
        searchCommunity()
    }
}

extension CommunityListViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "コミュニティは見つかりませんでした", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "検索条件を変更してみてください", attributes: attributes)
    }
}
