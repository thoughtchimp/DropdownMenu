//
//  NavigationController.swift
//  MediumMenu
//
//  Created by Thought Chimp on 30/05/16.
//  Copyright © 2016 ThoughtChimp. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var menu: DropdownMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let dashboardViewController = storyboard.instantiateViewControllerWithIdentifier("Dashboard") as! DashboardViewController
        setViewControllers([dashboardViewController], animated: false)

        let item1 = DropdownMenuItem(title: "Dashboard") {
            let dashboardViewController = storyboard.instantiateViewControllerWithIdentifier("Dashboard") as! DashboardViewController
            self.setViewControllers([dashboardViewController], animated: false)
        }
        
        let item2 = DropdownMenuItem(title: "History") {
            let historyViewController = storyboard.instantiateViewControllerWithIdentifier("History") as! HistoryViewController
            
            self.setViewControllers([historyViewController], animated: true)
        }
        
        let item3 = DropdownMenuItem(title: "Statistics") {
            let statisticsViewController = storyboard.instantiateViewControllerWithIdentifier("Statistics") as! StatisticsViewController
            self.setViewControllers([statisticsViewController], animated: false)
        }

        let item4 = DropdownMenuItem(title: "Settings") {
            let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("Settings") as! SettingsViewController
            self.setViewControllers([settingsViewController], animated: false)
        }
        
        let item5 = DropdownMenuItem(title: "Sign out") {
            let signoutViewController = storyboard.instantiateViewControllerWithIdentifier("Signout") as! SignoutViewController
            self.setViewControllers([signoutViewController], animated: false)
        }

        menu = DropdownMenu(item1: item1, item2: item2, item3: item3, item4: item4, otherItems:  [item5,item4,item3,item2,item4,item3,item2,item4,item3,item2], forViewController: self)
//        menu?.textColor = UIColor.blackColor()
//        menu?.menuBackgroundColor = UIColor(rgba: "#ffe400")
    }
    
    func showMenu(sender: UINavigationItem) {
        menu?.show()
    }
}
