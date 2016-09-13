//
//  ZDSearchBar.swift
//  通讯录
//
//  Created by zhudong on 16/9/12.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

let ValueChangedNotification = "valueChagedNotification"
class ZDSearchBar: UIView {
    class func loadSearchBar() -> ZDSearchBar {
         let searchBar = NSBundle.mainBundle().loadNibNamed("ZDSearchBar", owner: nil, options: nil).first
        debugPrint("\(searchBar)")
        return searchBar as! ZDSearchBar
    }
    
    @IBOutlet weak var textF: UITextField!
    override func awakeFromNib() {
        let imageView = UIImageView(image: UIImage(named: "set"))
        imageView.sizeToFit()
        imageView.backgroundColor = UIColor.grayColor()
        self.textF.leftViewMode = .Always
        self.textF.leftView?.frame = imageView.bounds
        self.textF.leftView = imageView
    }
    @IBOutlet weak var rightConst: NSLayoutConstraint!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBAction func beginEdit(sender: AnyObject) {
        self.rightConst.constant = self.cancelBtn.bounds.size.width
        UIView.animateWithDuration(0.25) { 
            self.layoutIfNeeded()
        }
    }
    var btnClickDelegate: ((search:ZDSearchBar) -> (Void))?
    @IBAction func cancelBtnClick(sender: AnyObject) {
        self.rightConst.constant = 0
        UIView.animateWithDuration(0.5) {
            self.layoutIfNeeded()
        }
        self.btnClickDelegate?(search: self)
    }
    @IBAction func valueChaged(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(ValueChangedNotification, object: nil, userInfo: ["str" : self.textF.text!])
    }
}
