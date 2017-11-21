//
//  ViewController.swift
//  FillMeUp
//
//  Created by Varun Rathi on 19/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var btnReplay:UIButton!
    @IBOutlet weak var btnNew:UIButton!
    @IBOutlet weak var pickerView:UIPickerView!
    @IBOutlet weak var lblScore:UILabel!
    
    var arrSentences:[Sentence] = []
    var arrHints:[String] = [""]
    
    // This gameInfo will manage user game difficults. as the user successfully answers all the answers , increase the level/ number of questions per level
    
    var gameInfo:GameLevel = {
        let gameLevel = GameLevel()
        return gameLevel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func callWebServiceToFetchText()
    {
        let apiClient = APIClient()
        apiClient.request(urlString: URLConstants.kBaseURL, parameters: nil) { (json, error, status) in
            // Check if data recieved is correct
            if status == true {
                // Check for string
                if let jsonStr = json.string {
                    // Convert string -> [String]/ [Sentences]
                     let arrStrings = Utility.splitSentences(from: jsonStr, limit: self.gameInfo.questionCount)
                    
                    self.arrSentences = arrStrings.map({ (string) -> Sentence in
                        return Sentence(with: string)
                    })
                    
                    Utility.reloadTableViewOnMainThread(tableView: self.tableView)

                }
            }
            else // Show Error
            {
                
            }
        }
        
    }
    
    func btnSubmitClicked()
    {
        let score =  Utility.calculateScore(from: arrSentences)
        
        lblScore.text = "\(score)"
    }
        
        
}

extension ViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSentences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.QuestionCellId, for: indexPath) as! QuestionTableCell
        
        let sentence = arrSentences[indexPath.row]
        cell.sentence = sentence
        cell.configureCell()
        return cell
    }
}
extension ViewController:UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrHints.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrHints[row]
    }
}
extension ViewController:UIPickerViewDelegate
{
    
    
}

