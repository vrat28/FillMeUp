//
//  QuestionTableCell.swift
//  FillMeUp
//
//  Created by Varun Rathi on 19/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

class QuestionTableCell: UITableViewCell {

    @IBOutlet weak var lblText:UILabel!
    
    var sentence:Sentence!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell()
    {
        hideWord()
    }
    
    func hideWord()
    {
        guard let range = sentence.range,let  missing = sentence.missingText else {return }
  
        let newRange = Range(range,in :sentence.text)
        var text = sentence.text
        text = text?.replacingOccurrences(of: missing, with: " ", options: .caseInsensitive, range: newRange)
        
        var mutableString:NSMutableAttributedString = NSMutableAttributedString(string: text!)
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        mutableString.addAttributes(underlineAttribute, range: range)

        lblText.attributedText = mutableString
       
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
