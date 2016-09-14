//
//  ZDNetworkTools.swift
//  通讯录
//
//  Created by zhudong on 16/9/13.
//  Copyright © 2016年 zhudong. All rights reserved.
//

import UIKit

enum HttpMethods: Int {
    case Post
    case Get
}
struct API {//http://127.0.0.1/tongxunlu.txt
    static let baseUrl = "http://127.0.0.1/"
    static let url = "tongxunlu.txt"
}

class ZDNetworkTool: AFHTTPSessionManager{
    //swift中的单例
    static let shareNetworkTool: ZDNetworkTool = {
        let baseUrl = NSURL(string: API.baseUrl)
        let tool = ZDNetworkTool(baseURL: baseUrl)
        return tool
    }()
    func request(method: HttpMethods,urlString: String,parameters: AnyObject?,finish:((responseObject: AnyObject?, error: NSError?) -> ())){
        let success = { (dataTask: NSURLSessionDataTask, result: AnyObject?) -> Void in
            finish(responseObject: result, error: nil)
        }
        let failure = { (dataTask: NSURLSessionDataTask?,error: NSError?) -> Void in
            finish(responseObject: nil, error: error)
        }
        if method == HttpMethods.Get {
            GET(urlString, parameters: parameters, progress: nil,success: success, failure: failure)
        }else if method == HttpMethods.Post{
            POST(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            debugPrint("没有定义请求方法")
        }
        
    }
}
extension ZDNetworkTool{

    func loadData(){
        GET("http://127.0.0.1/tongxunlu.txt", parameters: nil, success: { (dataTask, respose) in
            print("\(respose)")
            }) { (_, error) in
                print("\(error)")
        }
       request(.Get, urlString: API.url, parameters: nil) { (responseObject, error) in
            debugPrint("\(responseObject)")
        }
    }
}
