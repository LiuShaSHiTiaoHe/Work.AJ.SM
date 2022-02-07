//
//  NetWorkManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import Moya
import SwiftyUserDefaults
import ObjectMapper
import SwiftyJSON

final class NetWorkManager {
    
    static let shared = NetWorkManager()
    
    func initNetWork(){
        Network.Configuration.default.timeoutInterval = 10
        Network.Configuration.default.plugins = [NetworkIndicatorPlugin()]
        Network.Configuration.default.replacingTask = { (target: TargetType) -> Task in
            let url = target.baseURL.absoluteString + target.path
            var task = target.task
            switch task {
            case .requestParameters(let parameters, let encoding):
                if parameters.has(key: "ekey"), let eValue = parameters["ekey"] as? String {
                    let eParameters = GDataManager.shared.headerMD5(parameters, eValue)
                    task = .requestParameters(parameters: eParameters, encoding: encoding)
                }
            default:
                break
            }
            logger.shortLine()
            logger.info("url: \(url)")
            logger.info("endPoint:  \(task)")
            logger.shortLine()
            return task
        }
    }
    
}

class ResponseModel {
    var code: Int = -999
    var message: String = ""
    var data: String = ""
}

let dataKey = "data"
let messageKey = "error"
let codeKey = "status"
let successCode: Int = 0
let JsonDecodeErrorCode: Int = 1000000
let ConnectionFailureErrorCode: Int = 9999

typealias RequestModelSuccessCallback<T:Mappable> = ((T,ResponseModel?) -> Void)
typealias RequestModelsSuccessCallback<T:Mappable> = (([T],ResponseModel?) -> Void)
typealias RequestFailureCallback = ((ResponseModel) -> Void)
typealias errorCallback = (() -> Void)

extension TargetType {

    func NetWorkRequest(successCallback:@escaping RequestFailureCallback, failureCallback: RequestFailureCallback? = nil, showError: Bool = false) -> Cancellable? {
        return Network.default.provider.request(MultiTarget(self)) { result in
            switch result {
            case let .success(response):
                do {
                    let jsonData = try JSON(data: response.data)
                    #if DEBUG
                    logger.info("\(self.baseURL)\(self.path) --- \(self.method.rawValue) ----> responseData：\(jsonData)")
                    #endif
                    let respModel = ResponseModel()
                    respModel.code = jsonData[codeKey].int ?? 0
                    respModel.message = jsonData[messageKey].stringValue

                    if respModel.code == successCode {
                        respModel.data = jsonData[dataKey].rawString() ?? ""
                        successCallback(respModel)
                    } else {
                        errorHandler(code: respModel.code , message: respModel.message , showError: showError, failure: failureCallback)
                        return
                    }
                } catch {
                    // JSON解析失败
                    errorHandler(code: JsonDecodeErrorCode, message: String(data: response.data, encoding: String.Encoding.utf8)!, showError: showError, failure: failureCallback)
                }
            case let .failure(error):
                switch error {
                case .underlying(let nserror, _):
                    switch nserror.asAFError {
                    case .sessionTaskFailed(let e as NSError):
                        errorHandler(code: e.code, message: e.localizedDescription, showError: showError, failure: failureCallback)
                        return
                    default:
                        break
                    }
                default :
                    break
                }
                let moyaError = error as NSError
                errorHandler(code: moyaError.code, message: "Connectionfailed".localized(), showError: showError, failure: failureCallback)
            }
        }
    }
    
    /// 错误处理
    private func errorHandler(code: Int, message: String, showError: Bool, failure: RequestFailureCallback?) {
        logger.info("errorHandler：\(code)--\(message)")
        judgeCondition("\(code)")
        let model = ResponseModel()
        model.code = code
        model.message = message
//        if needShowFailAlert {
//            if let currentVC = UIViewController.currentViewController() {
//                BBToastManager.shared.showToast(.error, currentVC.view,message)
//            }
//        }
        failure?(model)
    }
    
    private func judgeCondition(_ flag: String?) {
        switch flag {
        case "401", "403":
//            if GLobalDataManager.shared.checkLoginState() {
//                GLobalDataManager.shared.removeUserData()
//                NotificationCenter.default.post(name: .kUserLogOut, object: nil)
//            }
            break // token失效
        default:
            return
        }
    }

}



