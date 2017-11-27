//
//  ViewController.swift
//  FillMeUp
//
//  Created by Varun Rathi on 19/11/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import ChameleonFramework
import PopupDialog
import TagListView

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var btnReplay:UIButton!
    @IBOutlet weak var viewPickerContainer:UIView!
    @IBOutlet weak var pickerView:UIPickerView!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblCurrentLevel:UILabel!
    
    @IBOutlet weak var tagListView:TagListView!
    @IBOutlet weak var contraintPickerHeight:NSLayoutConstraint!
    
    var currentActiveCell:Int?
    var arrSentences:[Sentence] = []
    var arrHints:[String] = [" "]
    
    var offsetDistance :CGFloat = 0
    var isRowBlocked:Bool = false
    var isGameRunning:Bool = false
    
    // This gameInfo will manage user game difficults. as the user successfully answers all the answers , increase the level/ number of questions per level
    
    var gameInfo:GameLevel = {
        let gameLevel = GameLevel()
        return gameLevel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupColors()
        automaticallyAdjustsScrollViewInsets = false
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        viewPickerContainer.translatesAutoresizingMaskIntoConstraints = false
        callWebServiceToFetchText()
        setUpTagListView()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        setDefaultLevel()
        hidePickerWithoutAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tagListView.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUpTagListView()
    {
        tagListView.textFont = UIFont.systemFont(ofSize: 24)
        tagListView.alignment = .center
    }
    
    func addTagsToTagList(tags:[String]) {
        
        tagListView.removeAllTags()
        for tag in tags  {
            
            let tagview = tagListView.addTag(tag)
            let index  = arrHints.index(of: tag)
            tagview.tag = (index)!
            tagview.isSelected = false
            tagview.selectedBackgroundColor = UIColor.flatGreen
            tagview.backgroundColor = UIColor.flatRed
   
        }
        
    }
    
    func setupColors()
    {
        //self.pickerView.backgroundColor = FlatTeal()
        lblCurrentLevel.textColor = FlatSkyBlue()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape == true {
            
            contraintPickerHeight.constant = 150
            
        }
        else
        {
             contraintPickerHeight.constant = 260
        }
        
        
        viewPickerContainer.layoutIfNeeded()
    }
    
    func setupNavBar()
    {
        navigationController?.navigationBar.barTintColor = FlatTeal()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Fill Me Up"
        
        let rightBarButton = UIBarButtonItem(title: "Submit", style: .done, target:self, action: #selector(btnSubmitClicked))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func configurePicker()
    {
        DispatchQueue.main.async {
           // self.pickerView.delegate = self
           // self.pickerView.dataSource = self
            
            self.tagListView.delegate = self
            self.addTagsToTagList(tags: self.arrHints)
        }
       
    }
    
    func refreshUI()
    {
        // set Pickerview datasources as the array of hints
        configurePicker()
        
        self.stopActivityIndicator()
        
        // Reload tableView on Dispatch Queue
        Utility.reloadTableViewOnMainThread(tableView: self.tableView)
        
    }
    
    //MARK:- Activity Indicator
    
   func startActivityIndicator()
    {
        DispatchQueue.main.async {
            let activityIndicator = ActivityIndicator.shared
            activityIndicator.startLoader(on: self.view)
        }
        
    }
    
   func  stopActivityIndicator()
    {
        DispatchQueue.main.async {
            let activityIndicator = ActivityIndicator.shared
            activityIndicator.stopLoader()
        }
        
    }
    
    //MARK:- Network request
    
    func callWebServiceToFetchText()
    {
        
        startActivityIndicator()
        let apiClient = APIClient()
        let url = ContentQuery.getRandomContentUrlString()
        apiClient.get(urlString:url) { (json, error, status) in
            if status == true {
                
                if let jsonStr = ContentExtractor.getContentFrom(json: json){
                    // If response is correct-> Update Game state
                    
                    self.isGameRunning = true
                    DispatchQueue.main.async {
                        self.changeGameStatus(with:true)
                    }
                    
                    // Convert string -> [String]/ [Sentences]
                      let arrStrings = Utility.splitSentences(from: jsonStr, limit: self.gameInfo.questionCount)
                    // Convert Array of String array of Models
                    self.arrSentences = arrStrings.map({ (string) -> Sentence in
                        return Sentence(with: string)
                    })
                    
                    // Prepare sentences by grouping tags based on lexical analysis of sentence
                    let response =  WordJumble.prepareQuestions(sentences: self.arrSentences, with: self.gameInfo)
                    
                    // This will return Tuple of Manipulated sentences( a word would be removed from each text), and array of removed words, which we will use as Hint options
                    
                    if let hints = response.1 {
                       // self.arrSentences = processedSentences
                        self.arrHints = hints.shuffled()
                        self.refreshUI()
                    }
                    else
                    {
                        // Error parsing sentences
                    }
                }
                
            }
            
            else
            {
                self.stopActivityIndicator()
            }
        }
    }
    
    @IBAction func btnReplayClicked(sender:AnyObject) {
        self.isGameRunning = false
        setDefaultLevel()
        callWebServiceToFetchText()
        updateLevel()
    }
    
    
    func btnSubmitClicked()
    {
        if isGameRunning {
            isGameRunning = false
        }
        
        changeGameStatus(with: false)
        calculateScore()
        
        // Check if all answers are correct, If Yes-> Increment Difficulty Level
        if gameInfo.score == gameInfo.questionCount {
            gameInfo.increaseLevel()
            updateLevel()
            callWebServiceToFetchText()
            isGameRunning = true
        }
        else {
            showDialog()
        }
    }
    
    //MARK:- Game Logic
    
    func setDefaultLevel()
    {
        isGameRunning = false
        gameInfo.level = GameDefaults.initialLevel
        gameInfo.questionCount = GameDefaults.questionCount
        gameInfo.score = GameDefaults.initialScore
        gameInfo.cumulativeTotal = GameDefaults.initialScore
    }
    
    func updateLevel()
    {
        lblCurrentLevel.text = "\(gameInfo.level)"
    }
    
    func changeGameStatus(with gameStarted:Bool)
    {
        if gameStarted {
            
            lblStatus.text = "Running"
            lblStatus.textColor = FlatGreen()
        }
        else
        {
            lblStatus.text = "Stopped"
            lblStatus.textColor = FlatRed()
        }
    }
    
    func calculateScore()
    {
        var score = 0
        for sentence in arrSentences {
            
            if let answer = sentence.answer {
                
                if sentence.missingText == answer {
                    
                    score = score + 1;
                    sentence.score = 1;
                    
                }
            }
        }
        
        gameInfo.score = score
        gameInfo.cumulativeTotal = score + gameInfo.cumulativeTotal
    }
    
    func pushResultsScreen()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:StoryboardIdentifer.ResultsScreen) as! ResultsViewController
        vc.arrSentences = arrSentences
        vc.gameInfo = gameInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showDialog()
    {
        let popup = Utility.getPopupDialog(title: StringConstants.kPopupTitle, and: StringConstants.kPopupMessage)
        let confirmBtn = DefaultButton(title: StringConstants.kPopupOption1, height: 50) {
            self.pushResultsScreen()
        }
        let cancelBtn = CancelButton(title: StringConstants.kPopuoOption2, height: 50, dismissOnTap: true, action:nil)
        
        popup.addButtons([confirmBtn,cancelBtn])
       present(popup, animated: true, completion: nil)
        
    }
    
    func showDialogForNewGame()
    {
        let popup = Utility.getPopupDialog(title: StringConstants.kPopupTitle, and: StringConstants.kPopupMessageGameOver)
        
        let dismissBtn = CancelButton(title: StringConstants.kpopupDismiss, height: 40, dismissOnTap: true, action:nil)
        popup.addButton(dismissBtn)
        present(popup, animated: true, completion: nil)
        
    }
    
    //MARK: - Picker functions
    
    @IBAction func pickerDoneButtonClicked(sender:UIBarButtonItem)
    {
        
      //  let selectedOption = pickerView.selectedRow(inComponent: 0)
      //  pickerView(self.pickerView, didSelectRow: selectedOption, inComponent: 0)
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
        if isRowBlocked {
            isRowBlocked = false
            shiftTableViewDown()
        }
        
        
        UIView.animate(withDuration: 0.2) {
            self.viewPickerContainer.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.viewPickerContainer.frame.size.width, height: self.viewPickerContainer.frame.size.height)
        }
    }
    
    func hidePickerWithoutAnimation()
    {
        
        self.viewPickerContainer.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.viewPickerContainer.frame.size.width, height: self.viewPickerContainer.frame.size.height)
    }
    
    func isRowBlocked(forIndex: Int)-> CGFloat
    {
        let indexpath = IndexPath(row: forIndex, section: 0)
        let cell = tableView.cellForRow(at: indexpath) as! QuestionTableCell
        let cellEndPoint = cell.frame.origin.y +  cell.frame.size.height
        let pickerStartingPoint = view.bounds.height - viewPickerContainer.frame.height
        
        return cellEndPoint - pickerStartingPoint
    }
    

    
   
    func swiftTableViewUp()
    {

        tableView.contentOffset = CGPoint(x: 0, y:offsetDistance + viewPickerContainer.bounds.height)
    }
    
    func shiftTableViewDown()
    {
       tableView.contentOffset = CGPoint(x: 0, y:offsetDistance  - viewPickerContainer.bounds.height)
       offsetDistance = 0
    }

}

// MARK:- TableView Methods
extension QuestionViewController:UITableViewDataSource {
    
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
        cell.delegate = self
        cell.index = indexPath.row
        cell.configureCell()
        return cell
    }
}

extension QuestionViewController:UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrHints.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = arrHints[row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
}
extension QuestionViewController:UIPickerViewDelegate
{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sentence = arrSentences[currentActiveCell!]
        let answer = arrHints[row]
        sentence.answer = answer
        
        hidePicker()
        let indexPath = IndexPath(item: currentActiveCell!, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        
    }
    
}

extension QuestionViewController:QuestionCellDelegate {
    
    func cellTapped(at index: Int) {
        
        if isGameRunning {
            currentActiveCell = index
            
            let Hdiff = isRowBlocked(forIndex: index)
            
            if Hdiff > 0 {
                
                offsetDistance = Hdiff
                isRowBlocked = true
                swiftTableViewUp()
            }
            
            showPicker()
        }
        else
        {
            showDialogForNewGame()
        }
    }
}

extension QuestionViewController : TagListViewDelegate {
    
  
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
       let index = tagView.tag
   
      tagView.isSelected = !tagView.isSelected
        
        let sentence = arrSentences[currentActiveCell!]
        let answer = arrHints[index]
        
        if  let previousAnswer = sentence.answer {
            
            if  let previousindex = arrHints.index(of: previousAnswer) {
                 let previousTagView = tagListView.tagViews[previousindex]
                
                previousTagView.isSelected = false
                previousTagView.tagBackgroundColor = UIColor.flatRed
            }
        }
    
        sentence.answer = answer
        let indexPath = IndexPath(item: currentActiveCell!, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        
        
    }
}
