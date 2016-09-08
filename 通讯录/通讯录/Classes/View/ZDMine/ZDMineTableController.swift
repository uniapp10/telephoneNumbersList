//
//  ZDMineTableController.swift
//  通讯录
//
//  Created by zhudong on 16/8/26.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

let BtnHeight: CGFloat = 150
let ScreenSize: CGSize = UIScreen.mainScreen().bounds.size
let IsLogin = "IsLogin"
let Account = "Account"
let Pwd = "Pwd"
let LoginSuccessNotification = "LoginSuccessNotification"
let DataBasePath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("persons.sqlite")
let AccountsPath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("Accounts.plist")
let IconViewHeight: CGFloat = 80

class ZDMineTableController: UITableViewController {
    private var headerBtn: UIButton?
    private var loginView: UIView?
    private var tipLabel: UILabel?
    private var iconBtn: UIButton?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if NSUserDefaults.standardUserDefaults().boolForKey(IsLogin) {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .None
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        setupUI()
        let navItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(barButtonClik))
        self.navigationItem.leftBarButtonItem = navItem
        let rightItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(rightItemClick))
        rightItem.title = "注销"
        self.navigationItem.rightBarButtonItem = rightItem
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardFrameChange(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
    }
//    @objc private func keyboardFrameChange(notify: NSNotification){
//        let dict = notify.userInfo
//        let rect = dict![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
//        self.view.transform = CGAffineTransformMakeTranslation(0, (rect?.origin.y)! - ScreenSize.height)
//    }
    @objc private func rightItemClick(){
        let alertController = UIAlertController(title: "提示", message: "您确定要退出吗?", preferredStyle: .ActionSheet)
        let actionOne = UIAlertAction(title: "注销", style: .Destructive) { (_) in
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: IsLogin)
            self.tipLabel?.removeFromSuperview()
            self.loginView?.removeFromSuperview()
            self.createLoginView()
        }
        let actionTwo = UIAlertAction(title: "取消", style: .Cancel) { (_) in
            //
        }
        alertController.addAction(actionOne)
        alertController.addAction(actionTwo)
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    @objc private func barButtonClik(){
        debugLog("\(DataBasePath)")
        let database = FMDatabase(path: DataBasePath)
        if database.open() {
            let createSql = "create table if not exists persons(department text,position text,name text,telephone text,email text);"
            let result =  database.executeStatements(createSql)
            if result {
                debugLog("建表成功")
            }
        }
        
        let filePath = "/Users/zhudong/Desktop/newtongxunlu.txt"
        let contentStr = try! NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        var strArray = contentStr.componentsSeparatedByString("\\n")
        strArray.removeLast()
        strArray.removeFirst()
        let accountsPlist = NSMutableDictionary()
        for str in strArray {
            let array = str.componentsSeparatedByString("&")
            let insertStr = "INSERT INTO persons (department,position,name,telephone,email) VALUES ('\(array[1])','\(array[2])','\(array[3])','\(array[4])','\(array[5])');"
            database.executeStatements(insertStr)
            accountsPlist["\(array[3])"] = "\(array[4])"
        }
        accountsPlist.writeToFile(AccountsPath, atomically: true)
        database.close()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK: - setupUI
    private func setupUI(){
        let headerView = UIView(frame: CGRect(x: 0, y: 64, width: ScreenSize.width, height: BtnHeight))
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
//        blurEffectView.hidden = true
        let iconBtn = UIButton(type: .Custom)
        iconBtn.setBackgroundImage(UIImage(named: "1"), forState: .Normal)
        iconBtn.layer.cornerRadius = IconViewHeight * 0.5
        iconBtn.layer.masksToBounds = true
        iconBtn.addTarget(self, action: #selector(iconBtnClick(_:)), forControlEvents: .TouchUpInside)
        self.iconBtn = iconBtn
        btn.addSubview(iconBtn)
        iconBtn.snp_makeConstraints { (make) in
            make.center.equalTo(btn)
            make.height.width.equalTo(IconViewHeight)
        }
        let setBtn = UIButton(type: .Custom)
        setBtn.setImage(UIImage(named: "set"), forState: .Normal)
        setBtn.sizeToFit()
        headerView.addSubview(setBtn)
        setBtn.addTarget(setBtn, action: #selector(setBtnClick), forControlEvents: .TouchUpInside)
        setBtn.snp_makeConstraints { (make) in
            make.top.equalTo(headerView).offset(3 * Margin)
            make.right.equalTo(headerView.snp_right).offset( -3 * Margin)
        }
        self.tableView.tableHeaderView = headerView
        createLoginView()
    }
    @objc private func setBtnClick(){
        let storyboard = UIStoryboard(name: "Set", bundle: nil)
//        let setT
    }
    @objc private func iconBtnClick(btn: UIButton){
        let imagePickerC = UIImagePickerController()
        imagePickerC.delegate = self
        imagePickerC.allowsEditing = true
        let alertC = UIAlertController(title: "请选择图片来源", message: nil, preferredStyle: .ActionSheet)
        let attributes = [NSFontAttributeName : UIFont.systemFontOfSize(17),NSForegroundColorAttributeName : UIColor.greenColor()];
        let attriTitle = NSAttributedString(string: "请选择图片来源", attributes: attributes);
        alertC.setValue(attriTitle, forKey: "attributedTitle")
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraBtn = UIAlertAction(title: "拍照", style: .Default) { (_) in
                imagePickerC.sourceType = .Camera
                self.navigationController?.presentViewController(imagePickerC, animated: true, completion: nil)
            }
            alertC.addAction(cameraBtn)
        }
        if  UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum){
            let albumBtn = UIAlertAction(title: "相册", style: .Default, handler: { (_) in
                imagePickerC.sourceType = .SavedPhotosAlbum
                self.navigationController?.presentViewController(imagePickerC, animated: true, completion: nil)
            })
            alertC.addAction(albumBtn)
        }
        let cancelBtn = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertC.addAction(cancelBtn)
        let array = NSObject.getVariables(alertC)
        debugPrint("\(array)")
        self.navigationController?.presentViewController(alertC, animated: true, completion: nil)
    }
    private func createLoginView(){
        let mineCell = ZDMineCell()
        self.loginView = mineCell
        self.tableView.addSubview(mineCell)
        self.tableView.bringSubviewToFront(mineCell)
        mineCell.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(tableView)
            make.top.equalTo(tableView).offset(200)
        }
        mineCell.delegate = self
    }
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
        let offsetY = scrollView.contentOffset.y
//        print("\(offsetY)")
        var newH = BtnHeight - offsetY
        if newH < BtnHeight {
            newH = BtnHeight
        }
        let oldFrame = (headerBtn?.frame)!
        headerBtn?.frame = CGRect(x: 0, y:(offsetY + 64), width: oldFrame.width, height: newH)
    }
    lazy var accounts: NSDictionary? = {
//        let filePath: String = NSBundle.mainBundle().pathForResource("Accounts.plist", ofType: nil)!
        var dict = NSDictionary(contentsOfFile: AccountsPath)
        return dict
    }()
    
}
extension ZDMineTableController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //代理方法需要手动才可以显示
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        self.iconBtn?.setImage(UIImage(data: imageData!), forState: .Normal)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
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
                NSUserDefaults.standardUserDefaults().setObject(account, forKey: Account)
                NSUserDefaults.standardUserDefaults().setObject(pwd, forKey: Pwd)
                var subviewsArray = cell.subviews
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
                self.tipLabel = tipLabel
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
class ZDMineCell: UIView {
    //协议的准守类似类型名
    var delegate: ZDMineCellDelegate?
    var accountT: UITextField?
    var pwdT: UITextField?
    var loginBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        pwdT.secureTextEntry = true
        self.pwdT = pwdT
        let loginBtn = UIButton(type: .Custom)
        self.loginBtn = loginBtn
        loginBtn.setTitle("登录", forState: .Normal)
        loginBtn.backgroundColor = UIColor.greenColor()
        loginBtn.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        loginBtn.layer.cornerRadius = 15
        loginBtn.layer.masksToBounds = true
        loginBtn.addTarget(self, action: #selector(loginBtnClick), forControlEvents: .TouchUpInside)
        addSubview(accountL)
        addSubview(accountT)
        addSubview(pwdL)
        addSubview(pwdT)
        
        addSubview(loginBtn)
        accountL.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(4 * Margin)
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
//            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(300)
//            make.bottom.equalTo(self).offset(-3 * Margin)
            make.left.equalTo((ScreenSize.width - 300) * 0.5)
        }
    }
    @objc private func loginBtnClick(){
        self.delegate?.mineCellDidLoginClick(self)
    }
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        superview?.endEditing(true)
        if self.accountT?.frame.contains(point) == true {
            return self.accountT
        }
        if self.pwdT?.frame.contains(point) == true {
            return self.pwdT
        }
        if self.loginBtn?.frame.contains(point) == true {
            return self.loginBtn
        }
        return super.hitTest(point, withEvent: event)
    }
}
