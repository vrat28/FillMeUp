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
        // This function will take array of sentences and prepare them for questions
        
        var outputSentences = sentences
        var tokens = [String]()
        for aSentence in outputSentences {
            
            let string = aSentence.text
            // get tags and words in form of Dic
            
            // This is save the last word for corresponding tag
            let response = LinguisticTagger.getLexicalTagsFromString(with: string!)
            
            let tagDic = response.0
            // convert all the present tags in an array
            let tagArr = Array(tagDic.keys)

            // save current level
            
            // We will need to find right level , in case Tag for that level is not available,
            // For ex, for Player :level3 would correspond to Noun (So nouns will be hidden)
            // but if the sentences does not contains any noun, then we need to find next better option
            
            var currentLevel = level.difficultyMultiplier
            var str = Utility.getTagAccordingToLevel(level: level.difficultyMultiplier)
            
            while tagArr.contains(str) == false && currentLevel > 0 {
                str = Utility.findNextMatchingLevel(level: currentLevel)
                currentLevel = currentLevel - 1
            }
           
            // This meant we couldnt find any word suiting the player's level
            // so choose the first tag available in the sentence.
            
            
            if !tagArr.contains(str) {
                str = (tagArr.first)!
            }
            
            if let wordForTag = tagDic[str]  {
                // This Dic stores the range of the text hidden, This need to be saved as there might be multiple occurences of that word in the string, so we need to save corresponing range only
                let tagRangeDic = response.1
               // let range:NSRange = (aSentence.text as NSString).range(of: wordForTag)
                let range = tagRangeDic[wordForTag]
                tokens.append(wordForTag)
                aSentence.range = range
                aSentence.missingText = wordForTag
            }
        }
        
        return (outputSentences,tokens)
    }
    
}
