//
//  ViewController.swift
//  MediumMenu-Sample
//
//  Created by Thought Chimp on 30/05/16.
//  Copyright © 2016 ThoughtChimp. All rights reserved.
//

import UIKit
import DropdownMenu

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon = UIBarButtonItem(image: DropdownMenu.getBarButtonImage(), style: .Plain, target: navigationController, action: #selector(NavigationController.showMenu))
        icon.imageInsets = UIEdgeInsetsMake(-10, 0, 0, 0)
        icon.tintColor = UIColor.blackColor()
        navigationItem.leftBarButtonItem = icon
    } 
}
