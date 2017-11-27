//
//  Model.swift
//  FillMeUp
//
//  Created by Varun Rathi on 19/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import SwiftyJSON
class Sentence {
    
    var text:String!
   
    var missingText:String?
    {
        willSet{
            
            range = (text as NSString).range(of: newValue!)
          
    }
    }
    var answer:String?
    {
        
        willSet {
            
            range?.length = (newValue?.characters.count)!
        }
    }
    var missingLength:Int?
    
    var range:NSRange?
   
    var displayString:String? {
        
        get {
            
            if let answerText = answer {
        
                var rangeToSearch:NSRange = range!
                let maxLength:Int = max(answerText.characters.count, (missingText?.characters.count)!)
                rangeToSearch.length = maxLength
              

            let str = (text as NSString).replacingOccurrences(of: missingText!, with: answerText, options: .backwards, range:rangeToSearch)
            return str
        }
            else
            {
                let str = (text as NSString).replacingOccurrences(of:missingText!, with: " ", options: .backwards, range: range!)
               // let str = text.replacingOccurrences(of: missingText!, with: "x")
                return str
            }
        
        }
        
    }
    
    var score:Int = 0

    
    init(with text:String)
    {
        self.text = text
        
    }
    
}

class GameLevel :NSObject {
    
    var level:Int = 1
    var questionCount:Int = 10
    var score:Int?
    var cumulativeTotal:Int = 0
    
    
    func increaseLevel()
    {
        questionCount = questionCount + 1
        level  = level + 1
    }
}

// Struct for resetting game difficulty
struct GameDefaults {
    
  static  let initialLevel = 1
  static  let maxLevel = 6
  static let questionCount = 10
  static let initialScore = 0
}
