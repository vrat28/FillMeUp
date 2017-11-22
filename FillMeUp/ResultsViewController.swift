//
//  ResultsViewController.swift
//  FillMeUp
//
//  Created by Varun Rathi on 22/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import ChameleonFramework

class ResultsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

   
    var gameInfo:GameLevel!
    var arrSentences:[Sentence] = []
    @IBOutlet weak var tableView:UITableView!
     @IBOutlet weak var headerView:ResultsHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.backgroundColor = AppTheme.kBackgroundColorLightGray
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        setScore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setupNavBar()
    {
        navigationController?.navigationBar.barTintColor = FlatTeal()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Results"
    }
    
    func setScore()
    {
        if let score = gameInfo.score {
            headerView.lblScore.text = "\(score)"
        }
    }
    
    // MARK:- Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSentences.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ResultsCellId, for: indexPath) as! ResultDisplayCell
        cell.selectionStyle = .none
        let sentence = arrSentences[indexPath.section]
        cell.updateData(with: sentence)
        return cell
    }
    

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}



