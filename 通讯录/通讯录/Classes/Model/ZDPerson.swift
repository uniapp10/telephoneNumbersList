//
//  ZDPerson.swift
//  通讯录
//
//  Created by zhudong on 16/8/25.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

class ZDPerson: NSObject {
    var department: String?
    var position: String?
    var name: String?
    var telephone: String?
    init(dict: [String : AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        //
    }
    class  func  person(dict: [String : AnyObject]) -> ZDPerson {
        return ZDPerson.init(dict: dict)
    }
}
