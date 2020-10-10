//
//  New6TableViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/08.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class News6TableViewController: UIViewController, XMLParserDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var parser = XMLParser()
    var currentElementName: String!
    var newsItems = [NewsItems]()
    private let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.tableFooterView = UIView()
        setupParser()
    }
    
    @objc var scrollView: UIScrollView {
        return tableView
    }
    
    @objc func refreshTableView() {
        newsItems.removeAll()
        tableView.reloadData()
        setupParser()
        refresh.endRefreshing()
    }

    // MARK: - Partser
    
    private func setupParser() {
        
        let urlString = "https://news.yahoo.co.jp/rss/topics/domestic.xml"
        let url = URL(string: urlString)!
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = nil
        
        if elementName == "item" {
            self.newsItems.append(NewsItems())
        } else {
            currentElementName = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if newsItems.count > 0 {
            let lastItem = newsItems[newsItems.count - 1]
            
            switch currentElementName {
            case "title":
                lastItem.title = string
                
            case "link":
                lastItem.url = string
                
            case "pubDate":
                lastItem.pubDate = string
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.currentElementName = nil
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
}

// MARK: - Collection view

extension News6TableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 414, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewsCollectionViewCell
        let newsItem = newsItems[indexPath.row]
        
        cell.configureCell(imageUrl: newsItem.url!, newsItems: newsItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsItem = newsItems[indexPath.row]
        UserDefaults.standard.set(newsItem.url, forKey: "url")
        UserDefaults.standard.set(newsItem.title, forKey: "title")
    }
}

// MARK: - Table view

extension News6TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row != 0 {
            let label = cell.viewWithTag(1) as! UILabel
            label.text = newsItems[indexPath.row].title
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newsItem = newsItems[indexPath.row]
        UserDefaults.standard.set(newsItem.url, forKey: "url")
        UserDefaults.standard.set(newsItem.title, forKey: "title")
    }
}
