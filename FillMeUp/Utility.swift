//
//  Utility.swift
//  FillMeUp
//
//  Created by Varun Rathi on 19/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import PopupDialog

class Utility : NSObject
{
    
  class func splitSentences(from paragraph:String,limit:Int)->[String]
    {
        // Tokenize Strings based on lexical tokens.
        // So Strings splited should be logical sentences and not directly split on '.'
        // This is Needed to prevent incorrect splitting of string on like website(abc.mon) or any
        
        var r = [Range<String.Index>]()
        let t = paragraph.linguisticTags(
            in: paragraph.startIndex..<paragraph.endIndex,
            scheme: NSLinguisticTagSchemeLexicalClass,
            tokenRanges: &r)
        var result = [String]()
        let ixs = t.enumerated().filter {
            $0.1 == "SentenceTerminator"
            }.map {r[$0.0].lowerBound}
        var prev = paragraph.startIndex
        for ix in ixs {
            let r = prev...ix
            result.append(
                paragraph[r].trimmingCharacters(
                    in: NSCharacterSet.whitespaces))
            prev = paragraph.index(after: ix)
        }

        var count = result.count
        // If minimum count of sentences i not met , then append initial messages
        // by random, indexes
        if count < limit
        {
           
            while count < limit
            {
                let random = Int(arc4random_uniform(UInt32(count)))
                let sentence = result[random]
                result.append(sentence)
                count = count + 1
            }
        }
        
        
        // If sentences are greater than the required number -> Slice the array
        if count > limit {
            result = [String](result[0..<limit])
        }
        // In the end, Minimum mumber of sentences will be returned.
        return result
    }
    
    class func reloadTableViewOnMainThread(tableView:UITableView) {
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
  class   func getTagAccordingToLevel(level:Int)->String
    {
        switch level {
            
        case 1:
            return "Preposition"
            
        case 2:
            return "Determiner"
            
        case 3:
            return "Verb"
            
        case 4:
            return "Noun"
            
        case 5:
            return "Pronoun"
            
        case 6:
            return "Conjunction"
            
        default:
            return "Preposition"
        }
        
        
    }
    
   class func findNextMatchingLevel(level:Int)->String {
        
        return getTagAccordingToLevel(level: level + 1)
    }
    
    class func getPopupDialog(title:String,and message:String)-> PopupDialog
    {
        
            let popup = PopupDialog(title: StringConstants.kPopupTitle, message: StringConstants.kPopupMessage)
            
            let pv = PopupDialogDefaultView.appearance()
            pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
            pv.titleColor   = UIColor.white
            pv.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
            pv.messageColor = UIColor(white: 0.8, alpha: 1)
            
            
            let pcv = PopupDialogContainerView.appearance()
            pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
            pcv.cornerRadius    = 2
            pcv.shadowEnabled   = true
            pcv.shadowColor     = UIColor.black
        
            popup.buttonAlignment = .horizontal
            popup.transitionStyle = .bounceUp
            return popup
    }
    
    
}
