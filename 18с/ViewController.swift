//
//  ViewController.swift
//  18с
//
//  Created by sergey on 04.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import UIKit
import SQLite

class MyViewController: UITableViewController, UISearchBarDelegate {
    var  favProtocol: FavProtocol?
    
    let qDao = QDao()
    
    var questionArryDefault = [Quest]()
    var questionArray = [Quest]()
    var questionArraySearch = [Quest]()
    
    var searcBar = UISearchController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setupData()
        tableView.register(MyCell.self, forCellReuseIdentifier: "cell")
        tableView.register(MyCellWithImage.self, forCellReuseIdentifier: "cellImage")
        tableView.backgroundColor = UIColor(displayP3Red: 197/255, green: 202/255, blue: 232/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view, typically from a nib.
        setupSearch()
        
    }
    func setTitle(){
        navigationItem.title = "Все вопросы"
        
    }
    func setupData(){
        // let qDao = QDao()
        questionArryDefault = qDao.getAllQuest()
        questionArray = questionArryDefault
    }
    
    func setupSearch()  {
        searcBar = UISearchController(searchResultsController: nil)
        
        searcBar.searchResultsUpdater = self
        searcBar.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searcBar
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searcBar.searchBar.delegate = self
        
        searcBar.searchBar.scopeButtonTitles = ["Все", "Капитан", "Старший помошник", "Вахтенный помощник"]
        searcBar.searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltering()){
            return  questionArraySearch.count
        }else {
            
            return questionArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var question: Quest
        if(isFiltering()){
            question  = questionArraySearch[indexPath.row]
        } else {question = questionArray[indexPath.row]}
        
        let number = indexPath.row + 1
        
        question.number = "Вопрос \(number)"
        // question.img = "i"
        
        var cell : MyCell
        if let img = question.img {
            
            if (img.elementsEqual("имя картинки") || img.isEmpty){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
                cell.question = question
                cell.layoutSubviews()
                return cell
                
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "cellImage", for: indexPath) as! MyCellWithImage
                cell.question = question
                cell.layoutSubviews()
                return cell
                
            }
        }
        return UITableViewCell()
        
    }
    
    
    //    //// search
    //        func searchBarSearchButtonClicked  (_ searchBar: UISearchBar) {
    //
    //        if let serchString = searchBar.text{
    //            if var number = Int (serchString) {
    //                if number > questionArryDefault.count {
    //                    number =  questionArryDefault.count
    //                }
    //                if number == 0 {
    //                    number = 1
    //                }
    //                setDefaultQuestions()
    //
    //                let index = IndexPath(item: 0, section: number - 1)
    //                tableView.scrollToRow(at: index, at: .top, animated: false)
    //                searcBar.searchBar.endEditing(true)
    ////                tableView.searcBar.endEditing(true)
    //
    //            }else { searchInDB(searchString: serchString.lowercased())}
    //
    //        }
    //    }
    
    
    
    //    func setDefaultQuestions() {
    //        if (self.questionArray != self.questionArryDefault) {
    //            questionArray = questionArryDefault
    //            questionArraySearch = []
    //            tableView.reloadData()
    //        }
    //
    //    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let toFav = setFav(index: indexPath.row)
        return UISwipeActionsConfiguration(actions: [toFav])
    }
    
    func setFav(index: Int) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Отметить"){
            (action, view, complition) in
            
            var quest : Quest
            if self.isFiltering(){
                quest = self.questionArraySearch[index]
            } else {quest = self.questionArray[index]}
            
            
            let bol = self.addRemoveFromFav(id: quest.id!)
            
            if bol {
                self.favProtocol?.addInArray(quest: quest)
                self.favProtocol?.setAddStatus()
                complition(true)
            }
            
        }
        
        action.backgroundColor = UIColor(displayP3Red: 92/255, green: 107/255, blue: 192/255, alpha: 0.2)
        return action
    }
    
    func  addRemoveFromFav(id: Int) -> Bool{
        return qDao.setFav(idSet: id)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: selectedScope)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: Int = 0) {
       // print(searchBarIsEmpty)
        questionArraySearch = questionArray.filter({( quest : Quest) -> Bool in
            let hasCategoryMatch = (scope == 0) || (false)
            
            if searchBarIsEmpty() {
                if hasCategoryMatch {
                    return  true
                    
                }else{
                    switch scope {
                    case 2:
                        
                        return  quest.category!.contains("starpom2")
                        
                    case 1:
                        return  quest.category!.contains("cap2")
                        
                    case 3:
                        
                        return  quest.category!.contains("watch2")
                        
                    default:
                        return false
                    }
                    
                }
                
                
            } else {
                if hasCategoryMatch {
                    
                    return quest.body!.lowercased().contains(searchText.lowercased())
                }else{
                    switch scope {
                    case 2:
                        return  quest.category!.contains("starpom2") && quest.body!.lowercased().contains(searchText.lowercased())
                    case 1:
                        
                        return  quest.category!.contains("cap2") && quest.body!.lowercased().contains(searchText.lowercased())
                        
                    case 3:
                        
                        return  quest.category!.contains("watch2") && quest.body!.lowercased().contains(searchText.lowercased())
                    default:
                        return false
                    }
                    
                }
                //doesCategoryMatch && quest.body!.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
        
    }
    
    
}


// cat   starpom2  watch2  cap2  all

extension MyViewController: UISearchResultsUpdating {
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searcBar.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searcBar.searchBar.selectedScopeButtonIndex != 0
        return searcBar.isActive && (!searchBarIsEmpty () || searchBarScopeIsFiltering)
        
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        
        if searchController.isActive{
         
            
            let scope = searchController.searchBar.selectedScopeButtonIndex
            filterContentForSearchText(searcBar.searchBar.text!, scope: scope)
            
        } else {tableView.reloadData()
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var question: Quest
        if(isFiltering()){
            question  = questionArraySearch[indexPath.row]
        } else {question = questionArray[indexPath.row]}
        
        
        if !(question.img!.elementsEqual("имя картинки")  || question.img!.isEmpty){
            
            let vc = DetailQuestionImage()
            vc.question = question
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    
    
    
}

