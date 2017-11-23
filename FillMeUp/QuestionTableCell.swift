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
        guard let range = sentence.range,let  _ = sentence.missingText else {return }
        
        if let displaystr = sentence.displayString {
            
            if let _ = sentence.answer {
                setAttributedText(input: displaystr, range: range)
            }
            else {
              let xRange = NSMakeRange(range.location, 1)
            setAttributedText(input: displaystr, range: xRange)
            }
        }
    }
    
    func setAttributedText(input:String, range:NSRange)
    {
        let mutableString:NSMutableAttributedString = NSMutableAttributedString(string: input)
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
                                  NSForegroundColorAttributeName : UIColor.blue] as [String : Any]
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
