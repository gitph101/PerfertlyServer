//
//  PerfertlyServerTools.swift
//  PerfertlyServer
//
//  Created by 曲年 on 2017/1/15.
//
//

import Foundation
import MySQL
import PerfectLogger

let RequestResultSuccess: String = "SUCCESS"
let RequestResultFaile: String = "FAILE"
let ResultListKey = "list"
let ResultKey = "result"
let ErrorMessageKey = "errorMessage"
var BaseResponseJson: [String : Any] = [ResultListKey:[], ResultKey:RequestResultSuccess, ErrorMessageKey:""]

class BaseDataSQL {
    let dataBaseName = "perfect_note"
    var mysql : MySQL {
        get {
            return MySQLConnect.shareInstance(dataBaseName: dataBaseName)
        }
    }
    var responseJson: [String : Any] = BaseResponseJson
}

/// 操作用户相关的数据表
class UserDataSQL:BaseDataSQL {
    let userTableName = "user"
    /// 由用户名查询用户信息
    ///
    /// - Parameter userName: 用户名
    /// - Returns: 返回JSON数据
    func queryUserInfo(userName:String) -> String? {
        let statement = "select id, username from user where username = '\(userName)'"
        LogFile.info("执行SQL:\(statement)")
        // 运行查询（比如返回在options数据表中的所有数据行）
        let querySuccess = mysql.query(statement:statement)
        // 确保查询完成
        if !querySuccess{
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
            LogFile.error("\(statement)查询失败")
        }else {
            LogFile.info("SQL:\(statement)查询成功")
            let results = mysql.storeResults()!
            var dic = [String:String]() //创建一个字典数组用于存储结果
            results.forEachRow { row in
                guard let userId = row.first! else {//保存选项表的Name名称字段，应该是所在行的第一列，所以是row[0].
                    return
                }
                dic["userId"] = "\(userId)"
                dic["userName"] = "\(row[1]!)"
            }
            self.responseJson[ResultKey] = RequestResultSuccess
            self.responseJson[ResultListKey] = dic
        }
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    /// 由用户名和密码查询用户信息
    ///
    /// - Parameters:
    ///   - userName: 用户名
    ///   - password: 用户密码
    /// - Returns:
    func queryUserInfo(userName: String, password: String) -> String? {
        let statement = "select * from user where username='\(userName)' and password='\(password)'"
        let querySuccess = mysql.query(statement: statement)
        if !querySuccess {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "用户名或密码错误，请重新输入！"
            LogFile.error("\(statement)用户名或密码错误，请重新输入")
        }else{
            LogFile.info("SQL:\(statement)查询成功")
            let results = mysql.storeResults()!
            var dic = [String:String]() //创建一个字典数组用于存储结果
            results.forEachRow { row in
                guard let userId = row.first! else {//保存选项表的Name名称字段，应该是所在行的第一列，所以是row[0].
                    return
                }
                dic["userId"] = "\(userId)"
                dic["userName"] = "\(row[1]!)"
                dic["registerTime"] = "\(row[3]!)"
            }
            self.responseJson[ResultKey] = RequestResultSuccess
            self.responseJson[ResultListKey] = dic
        }
        guard let json = try?responseJson.jsonEncodedString() else{
            return nil
        }
        return json
    }
    
    /// insert user info
    ///
    /// - Parameters:
    ///   - userName: 用户名
    ///   - password: 密码
    func insertUserInfo(userName:String,password:String) -> String?{
        let values = "('\(userName)', '\(password)')"
        let statement = "insert into \(userTableName) (username, password) values \(values)"
        LogFile.info("执行SQL:\(statement)")
        let querySuccess = mysql.query(statement: statement)
        if !querySuccess {
            LogFile.error("\(statement)插入失败")
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "创建\(userName)失败"
            guard let josn = try? responseJson.jsonEncodedString() else {
                return nil
            }
            return josn
        }else{
            LogFile.info("插入成功")
            return queryUserInfo(userName: userName, password: password)
        }
    }
    
    
    

}
