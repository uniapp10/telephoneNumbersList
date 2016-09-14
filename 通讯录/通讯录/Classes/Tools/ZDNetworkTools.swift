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
    static let url = "tongxunlu1.txt"
}

class ZDNetworkTool: AFHTTPSessionManager{
    //swift中的单例
    static let shareNetworkTool: ZDNetworkTool = {
        let baseUrl = NSURL(string: API.baseUrl)
        let tool = ZDNetworkTool(baseURL: baseUrl)
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
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
        let url = NSURL(string: "http://127.0.0.1/tongxunlu1.txt")
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url!) { (data, response, error) in
            if error != nil {return}
            let contentStr = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            var strArray = contentStr.componentsSeparatedByString("\\n")
            strArray.removeLast()
            strArray.removeFirst()
            let accountsPlist = NSMutableDictionary()
            let database = FMDatabase(path: DataBasePath)
            if database.open() {
                let deleteSql = "drop table persons"
                let deleteResult =  database.executeStatements(deleteSql)
                if deleteResult {
                    debugLog("删除表格成功")
                }
                let createSql = "create table if not exists persons(department text,position text,name text,telephone text,email text);"
                let result =  database.executeStatements(createSql)
                if result {
                    debugLog("建表成功")
                }
            }
            for str in strArray {
                let array = str.componentsSeparatedByString("&")
                let insertStr = "INSERT INTO persons (department,position,name,telephone,email) VALUES ('\(array[1])','\(array[2])','\(array[3])','\(array[4])','\(array[5])');"
                database.executeStatements(insertStr)
                accountsPlist["\(array[3])"] = "\(array[4])"
            }
            accountsPlist.writeToFile(AccountsPath, atomically: true)
            database.close()
        }.resume()
    }
}
