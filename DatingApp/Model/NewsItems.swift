//
//  NewsItems.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/07.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import HTMLReader

class NewsItems {
    
    var title: String?
    var url: String?
    var pubDate: String?
    
    class func fetchThumnImgUrl(urlStr: String, completion: @escaping(URL) -> Void) {
        guard let targetURL = URL(string: urlStr) else { return }
        do {
            let sourceHTML = try String(contentsOf: targetURL, encoding: String.Encoding.utf8)
            let html = HTMLDocument(string: sourceHTML)
            let htmlElement = html.firstNode(matchingSelector: "[type^=\"image/jpeg\"]")
            
            guard let srcset = htmlElement?.attributes["srcset"] else { return }
            guard let imageUrl = URL(string: srcset) else { return }
            completion(imageUrl)
        }
        catch {}
    }
}
