//
//  ResultDisplayCell.swift
//  FillMeUp
//
//  Created by Varun Rathi on 23/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import ChameleonFramework

class ResultDisplayCell: UITableViewCell {

    @IBOutlet weak var lblSentence:UILabel!
    @IBOutlet weak var lblCorrect:UILabel!
    @IBOutlet weak var lblExplanation:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }
    
    func updateData(with sentence:Sentence)
    {
       // Incorrent Answer
        if sentence.score == 0 {
         
            lblCorrect.textColor = FlatRed()
            lblCorrect.text = StringConstants.kWrongText
            var detailStr = "Correct Answer : \(sentence.missingText!)\nYou Choosed:"
            if let answer = sentence.answer {
                detailStr = detailStr + "\(answer)"
                 lblSentence.attributedText = setAttributedString(with: sentence)
            }
            else
            {
                lblSentence.text = sentence.displayString
            }
            lblExplanation.text = detailStr
           
            
        } // Correct Answer
        else {
             lblSentence.text = sentence.text
            lblCorrect.textColor = FlatGreen()
            lblCorrect.text = StringConstants.kCorrectText
        }
        
    }

    
    func setAttributedString(with sentence:Sentence)-> NSMutableAttributedString
    {
        let mutableString:NSMutableAttributedString = NSMutableAttributedString(string: sentence.displayString!)
        let attribute = [NSForegroundColorAttributeName: UIColor.white]
        
        mutableString.addAttributes(attribute, range: sentence.range!)
        return mutableString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = nil
        lblCorrect.text = ""
        lblSentence.text = ""
        lblExplanation.text = ""
    }

}
