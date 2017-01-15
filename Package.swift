import PackageDescription

let package = Package(
    name: "PerfertlyServer",
    dependencies: [
        .Package(
        url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",
        majorVersion: 2, minor: 0),
        
       //Request请求日志过滤器
        .Package(url: "https://github.com/dabfleming/Perfect-RequestLogger.git",
                     majorVersion: 0),
        
        //将日志写入指定文件
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git",
                 majorVersion: 0, minor: 0),
 
        
        //MySql数据库依赖包
        .Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git",
                 majorVersion: 2, minor: 0),
    
        //Sqlite数据库依赖包
        .Package(
        url: "https://github.com/PerfectlySoft/Perfect-SQLite.git",
        majorVersion: 2, minor: 0)
                
    ]
)
