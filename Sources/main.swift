
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectRequestLogger
import PerfectLogger

// 创建HTTP服务器
let server = HTTPServer()

var routes = Routes()
// 为程序接口API版本v1创建路由表 demo
var api = Routes()
api.add(method: .get, uri: "/call1", handler: { requset, response in
    let params = requset.queryParams
    response.setBody(string: "程序接口API版本v1已经调用")
    response.completed()
})
api.add(method: .get, uri: "/call2", handler: { _, response in
    response.setBody(string: "程序接口API版本v2已经调用")
    response.completed()
})

//MARK: -Note
//注册
api.add(method: .post, uri: "/register") { (request, response) in
    guard let userName:String = request.param(name: "userName") else{
        LogFile.error("userName===nil")
        return
    }
    guard let password: String = request.param(name: "password") else {
        LogFile.error("password===nil")
        return
    }
    guard let json = UserDataSQL().insertUserInfo (userName: userName, password: password) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    //读取数据裤
    response.completed()

}
//注册
api.add(method: .get, uri: "/registerget") { (request, response) in
    let params = request.queryParams
    var userName:String? = nil
    var password:String? = nil
    for var user in params {
        if user.0  == "userName"{
            userName = user.1
        }
        if user.0  == "password"{
            password = user.1
        }
    }
    guard let json = UserDataSQL().insertUserInfo (userName: userName!, password: password!) else {
        LogFile.error("josn为nil")
        return
    }
    //
    response.setBody(string: json)
    //读取数据裤
    response.completed()
    
}



//登录
api.add(method: .get, uri: "/login") { (request, response) in
    guard let userName:String = request.param(name: "userName") else{
        LogFile.error("userName===nil")
        return
    }
    guard let password: String = request.param(name: "password") else {
        LogFile.error("password===nil")
        return
    }
    guard let json = UserDataSQL().queryUserInfo (userName: userName, password: password) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    response.completed()
}




// API版本v1
var api1Routes = Routes(baseUri: "/v1")
// 为API版本v1增加主调函数
api1Routes.add(_: api)
// 更新API版本v2主调函数
// 将两个版本的内容都注册到服务器主路由表上
routes.add(_: api1Routes)
server.addRoutes(routes)
// 设置文档根目录
// 这是可选的。
// 如果不希望提供静态内容就不需要设置。
// 设置文档根目录后，
// 系统会自动为路由增加一个静态文件处理句柄
server.documentRoot = "./webroot"
// 监听8181端口
server.serverPort = 8181

do {
    // 启动HTTP服务器
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("网络出现错误：\(err) \(msg)")
}


//
//let server = HTTPServer()
//
//// 注册您自己的路由和请求／响应句柄
//var routes = Routes()
//routes.add(method: .get, uri: "/", handler: {
//    request, response in
//    response.setHeader(.contentType, value: "text/html")
//    response.appendBody(string: "<html><title>你好，世界！</title><body>你好，世界！</body></html>")
//    response.completed()
//}
//)
//
//// 将路由注册到服务器上
//server.addRoutes(routes)
//
//// 监听8181端口
//server.serverPort = 8181
//
//do {
//    // 启动HTTP服务器
//    try server.start()
//} catch PerfectError.networkError(let err, let msg) {
//    print("网络出现错误：\(err) \(msg)")
//}

