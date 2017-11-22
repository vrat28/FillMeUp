//
//  ResultsHeaderView.swift
//  FillMeUp
//
//  Created by Varun Rathi on 23/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

class ResultsHeaderView: UIView {

    @IBOutlet weak var lblScore:UILabel!
    @IBOutlet weak var lblScoreText:UILabel!
    @IBOutlet weak var containerView:UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateScore(with game:GameLevel)
    {
        lblScore.text = "\(game.score ?? 0)"
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
