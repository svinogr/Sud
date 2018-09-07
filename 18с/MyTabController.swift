//
//  MyTabController.swift
//  18с
//
//  Created by sergey on 05.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import UIKit

class MyTabController: UITabBarController {
    
    let butto = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gen = MyViewController()
        let genNav = UINavigationController(rootViewController: gen)
        let tabGen = UITabBarItem()
        genNav.tabBarItem = tabGen
        tabGen.image = UIImage(named: "general")
        tabGen.title = "Все вопросы"
        

        let gen2 = MyFavController()
        let genNav2 = UINavigationController(rootViewController: gen2)
        let tabGen2 = UITabBarItem()
        genNav2.tabBarItem = tabGen2
        tabGen2.image = UIImage(named: "fav")
        tabGen2.title = "Отмеченые"
        
        gen.favProtocol = gen2
        
        let gen3 = ViewControllerMail()
        let genNav3 = UINavigationController(rootViewController: gen3)
        let tabGen3 = UITabBarItem()
        genNav3.tabBarItem = tabGen3
        tabGen3.image = UIImage(named: "mail")
        tabGen3.title = "Обратная связь"
        
       // fav.tabBarItem = tab
        // let mailNav = UINavigationController(rootViewController: mail)
        //var tab = UITabBarItem()
        //tab = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        //  tab.title = "ggg"
        //  nav.tabBarItem = tab
        //   nav.tabBarItem.title = "gen"
        // let ui = UINavigationController(rootViewController: nav)
        viewControllers = [genNav, genNav2, genNav3]
        //  var bar = UITabBarItem()
        //  bar = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
