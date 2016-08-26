//
//  ZDTabBarController.swift
//  通讯录
//
//  Created by zhudong on 16/8/25.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

class ZDTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        addChildControllers()
        selectedIndex = 3
//        self.tabBar.selectedItem = 4
//        self.tabBar.setValue(4, forKey: "")
    }
    private func addChildControllers(){
        for i in 0..<3 {
            let detailVC = ZDDetailControllerTableViewController()
            switch i {
            case 0:
                detailVC.title = "按部门"
                detailVC.tabBarItem.title = "按部门"
            case 1:
                detailVC.title = "按职位"
                detailVC.tabBarItem.title = "按职位"
            case 2:
                detailVC.title = "按姓名"
                detailVC.tabBarItem.title = "按姓名"
                //default不可以省略
            default: break
            }
            let nav = ZDNavigationController(rootViewController: detailVC)
            addChildViewController(nav)
        }
        let mine = ZDMineTableController()
        mine.tabBarItem.title = "我的"
        addChildViewController(mine)
    }
}
