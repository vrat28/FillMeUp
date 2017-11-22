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
   
    
    @IBOutlet weak var viewPickerContainer:UIView!
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
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hidePickerWithoutAnimation()
     //   callWebServiceToFetchText()
        testDummy()
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
                    
                    // Reload tableView on Dispatch Queue
                    Utility.reloadTableViewOnMainThread(tableView: self.tableView)

                }
            }
            else // Show Error
            {
                
            }
        }
        
    }
    
    func testDummy()
    {
        let text = StringConstants.testString
          let arrStrings = Utility.splitSentences(from: text, limit: self.gameInfo.questionCount)
        
      self.arrSentences =  arrStrings.map({ (string) -> Sentence in
            return Sentence(with: string)
        })
        
        // Reload tableView on Dispatch Queue
        Utility.reloadTableViewOnMainThread(tableView: self.tableView)
        
    }
    
    
    
    func btnSubmitClicked()
    {
        let score =  Utility.calculateScore(from: arrSentences)
        
        if score == gameInfo.questionCount
        {
            gameInfo.increaseLevel()
        }
        lblScore.text = "\(score)"
    }
    
    //MARK: - Picker functions
    
  @IBAction func pickerDoneButtonClicked(sender:UIBarButtonItem)
    {
        hidePicker()
        
    }
    
    func showPicker()
    {
        let pickerHeight = viewPickerContainer.frame.size.height
        let screenHeight = view.frame.size.height
        let offset = screenHeight - pickerHeight
        UIView.animate(withDuration: 0.2) {
            
            self.viewPickerContainer.frame = CGRect(x: 0, y: offset, width: self.viewPickerContainer.frame.size.width, height: self.viewPickerContainer.frame.size.height)
        }
    }
    
    func hidePicker()
    {
        UIView.animate(withDuration: 0.2) {
            self.viewPickerContainer.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.viewPickerContainer.frame.size.width, height: self.viewPickerContainer.frame.size.height)
        }
    }
    
    func hidePickerWithoutAnimation()
    {
        
        self.viewPickerContainer.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.viewPickerContainer.frame.size.width, height: self.viewPickerContainer.frame.size.height)
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

extension ViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        let loginButton = UIButton(type: .custom)
        loginButton.setTitle(StringConstants.kFooterButtonTitle, for:.normal)
        loginButton.addTarget(self, action: #selector(btnSubmitClicked), for: .touchUpInside)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor.blue
        loginButton.frame = CGRect(x: 0,y: 0, width: 130, height: 30)
        footerView.addSubview(loginButton)

        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
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

