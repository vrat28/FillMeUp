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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateData(sentence:Sentence)
   {
    
    
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
