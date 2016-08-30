//
//  ZDMineTableController.swift
//  通讯录
//
//  Created by zhudong on 16/8/26.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

let BtnHeight: CGFloat = 200
let ScreenSize: CGSize = UIScreen.mainScreen().bounds.size
let IsLogin = "IsLogin"
class ZDMineTableController: UITableViewController {
    private var headerBtn: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .None
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.rowHeight = 300
        let filePath = "/Users/zhudong/Desktop/a.txt"
        let contentData = NSData(contentsOfFile: filePath)
        let contentStr = NSString(data: contentData!, encoding: NSUnicodeStringEncoding)
        print("\(contentStr)")
        setupUI()
    }
    private func setupUI(){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: BtnHeight))
        let btn = UIButton(type: .Custom)
        btn.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: BtnHeight)
        let image = UIImage(named: "0")
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        btn.setBackgroundImage(image, forState: .Normal)
        self.headerBtn = btn
        headerView.addSubview(btn)
        btn.addSubview(blurEffectView)
        blurEffectView.snp_makeConstraints { (make) in
            make.edges.equalTo(btn)
        }
        self.tableView.tableHeaderView = headerView
        
        }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("\(offsetY)")
        var newH = BtnHeight - offsetY
        if newH < BtnHeight {
            newH = BtnHeight
        }
        let oldFrame = (headerBtn?.frame)!
        headerBtn?.frame = CGRect(x: 0, y:(offsetY), width: oldFrame.width, height: newH)
    }
    lazy var accounts: NSDictionary? = {
        let filePath: String = NSBundle.mainBundle().pathForResource("Accounts.plist", ofType: nil)!
        var dict = NSDictionary(contentsOfFile: filePath)
        return dict
    }()

}
extension ZDMineTableController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var mineCell: ZDMineCell? = tableView.dequeueReusableCellWithIdentifier("ZDMineCell") as? ZDMineCell
        if ((mineCell == nil)) {
            mineCell = ZDMineCell(style: .Default, reuseIdentifier: "ZDMineCell")
        }
        mineCell!.delegate = self
        mineCell?.selectionStyle = .None
        return mineCell!
    }
}
extension ZDMineTableController: ZDMineCellDelegate{
    func mineCellDidLoginClick(cell: ZDMineCell) {
        if (cell.accountT?.text?.characters.count > 0) && (cell.pwdT?.text?.characters.count > 0) {
            let account = (cell.accountT?.text)!
            let pwd = (cell.pwdT?.text)!
            if (accounts!["\(account)"] != nil) && ((accounts!["\(account)"] as? String) == pwd) {
                self.view.endEditing(true)
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: IsLogin)
                var subviewsArray = cell.contentView.subviews
                subviewsArray = subviewsArray.sort({ (view1, view2) -> Bool in
                    return view1.frame.maxY > view2.frame.maxY
                })
                for (index,value) in subviewsArray.enumerate() {
                    UIView.animateWithDuration(0.2, delay: Double(index) * 0.1, options: [], animations: { 
                        value.transform = CGAffineTransformMakeTranslation(0, ScreenSize.height * 0.5)
                        }, completion: { (_) in
                            value.removeFromSuperview()
                    })
                }
                let tipLabel = UILabel()
                tipLabel.textColor = UIColor.grayColor()
                tipLabel.text = "欢迎使用通讯录"
                tipLabel.sizeToFit()
                tipLabel.frame = CGRectMake((ScreenSize.width - tipLabel.bounds.size.width) * 0.5, ScreenSize.height, tipLabel.bounds.size.width, tipLabel.bounds.size.height)
                self.tableView.addSubview(tipLabel)
                UIView.animateWithDuration(1, delay: 1.2, usingSpringWithDamping: 0.25, initialSpringVelocity: 0, options: [], animations: {
                    tipLabel.transform = CGAffineTransformMakeTranslation(0, -300)
                    }, completion: nil)
            }else{
                let alertVC = UIAlertController(title: "提示", message: "用户名或密码错误", preferredStyle: .Alert)
                let sureBtn = UIAlertAction(title: "确定", style: .Default, handler: { (_) in
                    alertVC.dismissViewControllerAnimated(true, completion: nil)
                })
                alertVC.addAction(sureBtn)
                presentViewController(alertVC, animated: true, completion: nil)
            }
        }else{
            let alertVC = UIAlertController(title: "提示", message: "用户名和密码不能为空", preferredStyle: .Alert)
            let sureBtn = UIAlertAction(title: "确定", style: .Default, handler: { (_) in
                alertVC.dismissViewControllerAnimated(true, completion: nil)
            })
            alertVC.addAction(sureBtn)
            presentViewController(alertVC, animated: true, completion: nil)
        }
    }
}
//类型外面定义协议
 protocol ZDMineCellDelegate{
     func mineCellDidLoginClick(cell: ZDMineCell) -> Void
}
class ZDMineCell: UITableViewCell {
    //协议的准守类似类型名
    var delegate: ZDMineCellDelegate?
    var accountT: UITextField?
    var pwdT: UITextField?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        let accountL = UILabel()
        accountL.text = "账号:"
        let accountT = UITextField()
        accountT.placeholder = "请输入您的账号"
        self.accountT = accountT
        
        let pwdL = UILabel()
        pwdL.text = "密码:"
        let pwdT = UITextField()
        pwdT.placeholder = "请输入您的密码"
        self.pwdT = pwdT
        let loginBtn = UIButton(type: .Custom)
        loginBtn.setTitle("登录", forState: .Normal)
        loginBtn.backgroundColor = UIColor.greenColor()
        loginBtn.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        loginBtn.layer.cornerRadius = 15
        loginBtn.layer.masksToBounds = true
        loginBtn.addTarget(self, action: #selector(loginBtnClick), forControlEvents: .TouchUpInside)
        contentView.addSubview(accountL)
        contentView.addSubview(accountT)
        contentView.addSubview(pwdL)
        contentView.addSubview(pwdT)
        contentView.addSubview(loginBtn)
        accountL.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(50)
            make.left.equalTo(contentView).offset(4 * Margin)
        }
        accountT.snp_makeConstraints { (make) in
            make.centerY.equalTo(accountL)
            make.left.equalTo(accountL.snp_right).offset(Margin)
//            make.right.equalTo(contentView).offset(-2 * Margin)
            make.width.equalTo(250)
        }
        pwdL.snp_makeConstraints { (make) in
            make.left.equalTo(accountL)
            make.top.equalTo(accountL.snp_bottom).offset(3 * Margin)
        }
        pwdT.snp_makeConstraints { (make) in
            make.centerY.equalTo(pwdL)
            make.left.right.equalTo(accountT)
//            make.bottom.equalTo(contentView).offset(-3 * Margin)
        }
        loginBtn.snp_makeConstraints { (make) in
            make.top.equalTo(pwdL.snp_bottom).offset(30)
            make.centerX.equalTo(contentView)
            make.width.equalTo(300)
            make.bottom.equalTo(contentView).offset(-3 * Margin)
        }
    }
    @objc private func loginBtnClick(){
        self.delegate?.mineCellDidLoginClick(self)
    }
}