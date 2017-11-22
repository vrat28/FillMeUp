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
    var missingLength:Int?
    
    var range:NSRange?
   

    
    init(with text:String)
    {
        self.text = text
    }
    
}

class GameLevel :NSObject {
    
    var level:Int = 1
    var questionCount:Int = 10
    var difficultyMultiplier = 1
    var maxScore:Int?
    
    
    func increaseLevel()
    {
        questionCount = questionCount + 1
        difficultyMultiplier  = difficultyMultiplier + 1
    }
}
