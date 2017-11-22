//
//  Enums.swift
//  FillMeUp
//
//  Created by Varun Rathi on 22/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
 //Determiner Preposition Verb Noun OrganizationName  Pronoun Conjunction

// Difficulty Type : 1-6
enum DifficultyType:String {
    
    case Preposition
    case Determiner
    case Verb
    case Noun
    case Pronoun
    case Conjunction
    
    // To manage the difficulty level, a sentence is split in words and each word is lagged lexically of type Verb/ Noun/ Determiner.
    // Preposition is choosed as easiest , Conjuction as most difficult (Just a random assumption)
    // So, for first level, easiest available tag will be removed, and it will go up in subsequent levels.
    
    
    var difficultyLevel: Int {
        switch self {
        case .Preposition: return 1
        case .Determiner: return 2
        case .Verb: return 3
        case .Noun: return 4
        case .Pronoun: return 5
        case .Conjunction: return 6
        }
    }
}
