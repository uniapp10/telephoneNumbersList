//
//  UIViewSetFrame.swift
//  通讯录
//
//  Created by zhudong on 16/8/26.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

class SetViewFrame: UIView {
    var x: CGFloat? {
        get{
            return self.frame.minX
        }
        set(newX){
            let frame = self.frame
            let rect = CGRect(x: newX!, y: frame.minY, width: frame.width, height: frame.height)
            self.frame = rect
        }
    }
    var y: CGFloat? {
        get{
            return self.frame.minY
        }
        set(newY){
            let frame = self.frame
            let rect = CGRect(x: frame.minX, y: newY!, width: frame.width, height: frame.height)
            self.frame = rect
        }
    }
    
    //添加边框
    func addborder(top: Bool,left: Bool,bottom: Bool,right: Bool,borderColor: UIColor, borderWidth: CGFloat,borderCorner: CGFloat){
        if top {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: borderWidth)
            layer.backgroundColor = borderColor.CGColor
            self.layer.addSublayer(layer)
        }
        if left {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.bounds.size.height)
            layer.backgroundColor = borderColor.CGColor
            self.layer.addSublayer(layer)
        }
        if bottom {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: (self.bounds.size.height - borderWidth), width: self.bounds.size.width, height: borderWidth)
            layer.backgroundColor = borderColor.CGColor
            self.layer.addSublayer(layer)
        }
        if right {
            let layer = CALayer()
            layer.frame = CGRect(x: self.bounds.size.width - borderWidth, y: 0, width: borderWidth, height: self.bounds.size.height)
            layer.backgroundColor = borderColor.CGColor
            self.layer.addSublayer(layer)
        }
        if borderCorner != 0 {
            self.layer.cornerRadius = borderWidth
            self.layer.masksToBounds = true
        }
    }
}
