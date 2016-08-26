//
//  ZDDetailControllerTableViewController.swift
//  通讯录
//
//  Created by zhudong on 16/8/25.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

class ZDDetailControllerTableViewController: UITableViewController {
    private lazy var persons: [ZDPerson] = {
        let p = [["department":"信息部","position":"职员","name":"zhang","telephone":"18515665052"]]
        var personArray: [ZDPerson] = [ZDPerson]()
        for dict in p{
            let person: ZDPerson = ZDPerson.person(dict)
            personArray.append(person)
        }
        return personArray
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return persons.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let personCell = ZDPersonCell(style: .Default, reuseIdentifier: "personCell")
        personCell.person = persons[indexPath.row]
        return personCell
    }
}
