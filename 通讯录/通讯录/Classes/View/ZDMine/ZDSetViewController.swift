//
//  ZDSetViewController.swift
//  通讯录
//
//  Created by zhudong on 16/9/8.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

let SwitchState = "SwitchState"

class ZDSetViewController: UITableViewController {
    @IBOutlet weak var effectSwitch: UISwitch!
    //闭包的类型为()->(),可以用typealias来起别名
    var switchChanged:((setVC: ZDSetViewController,setSwitch: UISwitch) -> ())?
    typealias selectedImage = (image: UIImage) -> Void
    var didSelectImage: selectedImage?
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()
        self.effectSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(SwitchState)
    }
    //方法使用可以用类名.方法名来调用,而属性不可以
    @IBAction func effectSwitchChanged(sender: AnyObject) {
        self.switchChanged?(setVC: self,setSwitch: self.effectSwitch)
        NSUserDefaults.standardUserDefaults().setBool(self.effectSwitch.on, forKey: SwitchState)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
                let imagePickerC = UIImagePickerController()
                imagePickerC.sourceType = .SavedPhotosAlbum
                imagePickerC.allowsEditing = true
                imagePickerC.delegate = self;
                self.navigationController?.presentViewController(imagePickerC, animated: true, completion: nil)
//                self.navigationController?.pushViewController(imagePickerC, animated: true)
            }
        }
    }
}
extension ZDSetViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.didSelectImage?(image: image)
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.navigationController?.popToRootViewControllerAnimated(true);
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
//        self.navigationController?.popViewControllerAnimated(true)
    }
}
