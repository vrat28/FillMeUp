//
//  ContentExtractor.swift
//  FillMeUp
//
//  Created by Varun Rathi on 26/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ContentQuery {
    
    // Static titles for query
    static let contentTitles = ["Google","Twitter","Apple","Basketball","India","Germany","Youtube","Bodybuilding","Facebook","MTV","iOS","Singapore"]
    
    static func getRandomContentTitle() -> String
    {
        let randomIndex = arc4random_uniform(UInt32(contentTitles.count)) // Get random title for content
        return contentTitles[Int(randomIndex)]
    }
    
    static func getRandomContentUrlString() -> String {
        
        let randomTitle = getRandomContentTitle()
        // Substitute content title in Query
        let  url =  String(format: URLConstants.kBaseURL,randomTitle)
            return url
    }
    
}

// Struct to fetch String from json response

struct ContentExtractor {

   static func getContentFrom(json:JSON) -> String?
    {
        if let pageDic = json["query"]["pages"].dictionaryObject { // Check if pages are available
            
            // Get the first page id
            if  let pageId = Array(pageDic.keys).first {
                // extract the s
                if let jsonStr = json["query"]["pages"][pageId]["extract"].string {
                    return jsonStr
                }
        }
    }
        return nil
}
}
