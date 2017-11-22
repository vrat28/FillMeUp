//
//  LinguisticTagger.swift
//  FillMeUp
//
//  Created by Varun Rathi on 22/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

class LinguisticTagger : NSObject
{
    
    class  func getLexicalTagsFromString(with input : String) -> [String:String]
    {
        let excludedTypes = ["SentenceTerminator", "Punctuation"]
        
        let options = NSLinguisticTagger.Options.omitWhitespace.rawValue | NSLinguisticTagger.Options.joinNames.rawValue
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: Int(options))
        tagger.string = input
        
        let stringRange = NSRange(location: 0, length: input.utf16.count)
        
        var tags = [String:String]()
        tagger.enumerateTags(in: stringRange, scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: NSLinguisticTagger.Options(rawValue: options)) { tag, tokenRange, sentenceRange, stop in
            guard let range = Range(tokenRange, in: input) else { return }
            let token = input[range]
            
            //  Punctuation,  SentenceTerminator to be ignored
            if !excludedTypes.contains(tag)
            {
                 tags[tag] = token
            }
           
            print("\(tag): \(token)")
        }
        
        return tags
    }

    
}


