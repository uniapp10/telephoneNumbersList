//
//  UIView+Extension.swift
//  通讯录
//
//  Created by zhudong on 16/9/1.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

extension UIView{
    func findNavigationController() -> UINavigationController? {
        var next = self.nextResponder()
        while next != nil {
            if let nextObj = next as? UINavigationController {
                return nextObj
            }
            next = next!.nextResponder()
        }
        return nil
   
    }

}
func debugLog(item: Any){
    #if DEBUG
        print(item)
    #else
    #endif
}
