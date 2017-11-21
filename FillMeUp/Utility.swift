//
//  Utility.swift
//  FillMeUp
//
//  Created by Varun Rathi on 19/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit


class Utility : NSObject
{
  class  func calculateScore(from sentences:[Sentence])-> Int
    {
        var score = 0
        for sentence in sentences {
            if let hidden = sentence.missingText, let answer = sentence.answer {
                if hidden == answer {
                    score = score  + 1
                }
            }
        }
        return score
    }
    
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
        if count < Constant.kMaxSentences
        {
            while count < 10
            {
                let random = Int(arc4random_uniform(UInt32(count)))
                let sentence = result[random]
                result.append(sentence)
                count = count + 1
            }
        }
        
        return result
    }
    
    class func reloadTableViewOnMainThread(tableView:UITableView) {
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
}
