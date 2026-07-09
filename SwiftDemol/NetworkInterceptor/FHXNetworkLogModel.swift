//import Foundation
//
//struct FHXNetworkLogModel: Codable {
//
//    let id: String
//
//    /// 请求URL
//    let url: String
//
//    /// GET POST PUT...
//    let method: String
//
//    /// Header
//    let headers: [String:String]
//
//    /// 请求参数
//    let parameters: String
//
//    /// 响应内容
//    let response: String
//
//    /// 状态码
//    let statusCode: Int
//
//    /// 耗时（秒）
//    let costTime: TimeInterval
//
//    /// 错误
//    let errorMessage: String?
//
//    /// 时间
//    let time: Date
//
//    init(
//        id: String = UUID().uuidString,
//        url: String,
//        method: String,
//        headers: [String:String],
//        parameters: String,
//        response: String,
//        statusCode: Int,
//        costTime: TimeInterval,
//        errorMessage: String?,
//        time: Date = Date()
//    ) {
//
//        self.id = id
//        self.url = url
//        self.method = method
//        self.headers = headers
//        self.parameters = parameters
//        self.response = response
//        self.statusCode = statusCode
//        self.costTime = costTime
//        self.errorMessage = errorMessage
//        self.time = time
//    }
//}
