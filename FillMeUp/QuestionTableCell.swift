//
//  QuestionTableCell.swift
//  FillMeUp
//
//  Created by Varun Rathi on 19/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

protocol QuestionCellDelegate {
    
    func cellTapped(at index:Int)
}

class QuestionTableCell: UITableViewCell {

    @IBOutlet weak var lblText:UILabel!
    var sentence:Sentence!
    var index:Int!
    var delegate:QuestionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.contentView.addGestureRecognizer(tapGesture)
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
        
        let mutableString:NSMutableAttributedString = NSMutableAttributedString(string: text!)
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        mutableString.addAttributes(underlineAttribute, range: range)

        lblText.attributedText = mutableString
       
    }
    
    func cellTapped()
    {
        delegate?.cellTapped(at:index)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
