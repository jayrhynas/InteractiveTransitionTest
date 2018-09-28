//
//  NavViewController.swift
//  InteractiveTransitionTest
//
//  Created by Jayson Rhynas on 2018-09-28.
//  Copyright © 2018 Jayson Rhynas. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }


}

