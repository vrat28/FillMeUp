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
            let  str = text.replacingOccurrences(of:missingText!, with: answerText)
            return str
        }
            else
            {
                let str = text.replacingOccurrences(of: missingText!, with: "x")
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
    var difficultyMultiplier = 1
    var score:Int?
    
    
    func increaseLevel()
    {
        questionCount = questionCount + 1
        difficultyMultiplier  = difficultyMultiplier + 1
    }
}
