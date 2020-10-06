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

class CommunityListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var communityArray = [Community]()
    lazy var searchBar: UISearchBar = UISearchBar(frame: navigationController!.navigationBar.bounds)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
//        testBanner()
        
        setSearchBar()
        fetchCommunities()
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
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
        
        indicator.startAnimating()
        communityArray.removeAll()
        Community.fetchNumberCommunity { (community) in
            self.communityArray = community
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    private func fetchCreatedCommunity() {
        
        indicator.startAnimating()
        communityArray.removeAll()
        Community.fetchCreatedCommunity { (community) in
            self.communityArray = community
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    private func fetchRecommendedCommunity() {
        
        indicator.startAnimating()
        communityArray.removeAll()
        Community.fetchRecommendedCommunity { (community) in
            self.communityArray = community
            self.communityArray.shuffle()
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    private func searchCommunity() {
        
        indicator.startAnimating()
        communityArray.removeAll()
        Community.communitySearch(text: searchBar.text!) { (community) in
            self.communityArray = community
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    // MARK: - Helpers
    
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
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return NSAttributedString(string: "コミュニティは見つかりませんでした", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "検索条件を変更してみてください")
    }
}
