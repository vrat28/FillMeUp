//
//  WordJumble.swift
//  FillMeUp
//
//  Created by Varun Rathi on 22/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

class WordJumble : NSObject {
    
    static func  prepareQuestions(sentences : [Sentence], with level : GameLevel)-> ([Sentence]?,[String]?)
    {
        var outputSentences = sentences
        var tokens = [String]()
        for aSentence in outputSentences {
            
            let string = aSentence.text
            
            let tags = LinguisticTagger.getLexicalTagsFromString(with: string!)
            
            let range:NSRange = NSRange()
            let token:String = " "
            
            tokens.append(token)
            aSentence.range = range
            aSentence.missingText = token
            
        }
        
        return (outputSentences,tokens)
    }
    
}
