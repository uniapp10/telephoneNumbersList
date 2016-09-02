//
//  ZDHeader.swift
//  通讯录
//
//  Created by zhudong on 16/9/2.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

class ZDHeader: NSObject {
    var title: String?
    var isOpen = false
    var persons: [ZDPerson] = [ZDPerson]()
    override init() {
        super.init()
    }
    init(title: String){
        super.init()
        self.title = title
    }
}
