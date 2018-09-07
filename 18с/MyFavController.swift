//
//  MyFavController.swift
//  18с
//
//  Created by sergey on 05.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import UIKit
protocol FavProtocol {
  func  addInArray(quest: Quest)
    func setAddStatus()
    
}
class MyFavController: MyViewController {
    
    var isAdded : Bool = false
    
    override func setupData() {
        let qDao = QDao()
        questionArryDefault = qDao.getFav()
        questionArray = questionArryDefault
    }
    override func setTitle(){
        navigationItem.title = "Отмеченные"
        
    }
    
    override func addRemoveFromFav(id: Int) -> Bool{
        return qDao.deletFav(idSet: id)
    }
    
    override func setupSearch() {
        
    }
    
    override func setFav(index: Int) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Снять пометку"){
            (action, view, complition) in
            
            
            let quest = self.questionArray[index]
            
            let bol = self.addRemoveFromFav(id: quest.id!)
            if bol {
                self.questionArray.remove(at: index)
                let indexPuth = IndexPath(item: index, section: 0)
                self.tableView.deleteRows(at: [indexPuth], with: .bottom)
            }
            
                complition(true)
        
            
        }
        action.backgroundColor = UIColor(displayP3Red: 92/255, green: 107/255, blue: 192/255, alpha: 0.2)
        return action
    }
    override func viewWillAppear(_ animated: Bool) {
        if isAdded {
            tableView.reloadData()
            isAdded = false
        }
    }
}
extension MyFavController: FavProtocol{
    func setAddStatus() {
        isAdded = true
    }
    
    func addInArray(quest: Quest) {
        questionArray.append(quest)
    questionArryDefault.append(quest)

    }
}
