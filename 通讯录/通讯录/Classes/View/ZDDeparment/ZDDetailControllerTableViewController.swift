//
//  ZDDetailControllerTableViewController.swift
//  通讯录
//
//  Created by zhudong on 16/8/25.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

class ZDDetailControllerTableViewController: UITableViewController {
    private var hearders: [ZDHeader] = [ZDHeader]()
    let database = FMDatabase(path: DataBasePath)
    var param: String?
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if NSUserDefaults.standardUserDefaults().objectForKey(IsLogin)?.boolValue == true {
            debugLog("登录成功")
            if database.open() {

                switch self.navigationItem.title! {
                case "按部门"://select distinct name from table
                    param = "department"
                    break
                case "按职位"://select distinct name from table
                    param = "position"
                    break
                case "按姓名"://select distinct name from table
                    param = "name"
                    break
                default:
                    //
                    break
                }
                let  str = "SELECT distinct \(param!) FROM persons;"
                let result: FMResultSet = database.executeQuery(str, withArgumentsInArray: nil)
                while result.next() {
                    let title = result.stringForColumn("\(param!)")
                    let header = ZDHeader(title: title)
                    hearders += [header]
                }
                tableView.reloadData()
            }
            database.close()
        }else{
            self.hearders.removeAll()
            tableView.reloadData()
            let label = UILabel()
            label.text = "请您登陆查看详细信息"
            label.textColor = UIColor.grayColor()
            label.textAlignment = .Center
            tableView.backgroundView = label
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
    }
    
    let Header = "Header"
    let HeaderViewHeight: CGFloat = 30
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(Header) as? ZDHeaderView
        
        if headerView == nil {
            headerView = ZDHeaderView(reuseIdentifier: Header)
        }
        headerView?.tag = section
        headerView?.delegate = self
        let header = self.hearders[section]
        headerView?.header = header
        return headerView
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    //MARK: UITableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.hearders.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let header = self.hearders[section]
        return header.isOpen ? header.persons.count : 0
//        return header.persons.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let personCell = ZDPersonCell(style: .Default, reuseIdentifier: "personCell")
        personCell.selectionStyle = .None
        let header = self.hearders[indexPath.section]
        let person = header.persons[indexPath.row]
        personCell.person = person
        return personCell
    }
}
// MARK: - ZDHeaderViewTouchDelegate
extension ZDDetailControllerTableViewController: ZDHeaderViewTouchDelegate{
    func headerViewDidTouch(headerView: ZDHeaderView) {
        let header:ZDHeader = self.hearders[headerView.tag]
        header.isOpen = !header.isOpen
        if header.isOpen {
            self.findDetailData(header, headerView: headerView)
        }
        let section = NSIndexSet(index: headerView.tag)
        self.tableView.reloadSections(section, withRowAnimation: .Automatic)
    }
    func findDetailData(header: ZDHeader,headerView: ZDHeaderView){
        let str = header.title!
        let departmentStr = "SELECT *  FROM persons WHERE \(param!) = '\(str)';"
        if database.open() {
            let result: FMResultSet = database.executeQuery(departmentStr, withArgumentsInArray: nil)
            var persons: [ZDPerson] = [ZDPerson]()
            while result.next() {
//                print(result.stringForColumn("department"))
                let person = ZDPerson()
                person.department = result.stringForColumn("department")
                person.position = result.stringForColumn("position")
                person.name = result.stringForColumn("name")
                person.telephone = result.stringForColumn("telephone")
                person.email = result.stringForColumn("email")
                persons += [person]
            }
            header.persons = persons
        }else{
            header.persons.removeAll()
        }

    }
}


protocol ZDHeaderViewTouchDelegate {
    func headerViewDidTouch(headerView: ZDHeaderView) -> Void
}
class ZDHeaderView: UITableViewHeaderFooterView {
    var delegate: ZDHeaderViewTouchDelegate?
    var header: ZDHeader?{
        didSet{
            label.text = header?.title
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func  setupUI(){
        contentView.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(Margin)
            make.centerY.equalTo(contentView)
        }
        let sepV = UIView()
        sepV.backgroundColor = UIColor.blackColor()
        contentView.addSubview(sepV)
        sepV.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.delegate?.headerViewDidTouch(self)
    }
}