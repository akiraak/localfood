//
//  MainTabBarViewController.swift
//  localfood
//
//  Created by Akira Kozakai on 4/9/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    enum Tab: Int {
        case home
        case feed
        case post
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
    }

    func changeTab(tab: Tab) {
        selectedIndex = tab.rawValue
    }
}
