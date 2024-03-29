//
//  NetWorkManager.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation
import Moya
import SwiftyUserDefaults
import ObjectMapper
import SwiftyJSON
import SVProgressHUD
import CryptoSwift

// MARK: - Completion Callback Block Defines
typealias DefaultCompletion = (_ errorMsg: String) -> Void
typealias RequestModelCallback<T: Mappable> = (T, ResponseModel?) -> Void
typealias RequestModelsCallback<T: Mappable> = ([T], ResponseModel?) -> Void
typealias RequestBaseCallback = (ResponseModel, JSON?) -> Void
typealias RequestFailureCallback = (ResponseModel) -> Void
typealias DefaultSuccessCallback = (JSON) -> Void


// MARK: - Network Response Key
struct BaseResponseKey {
    static let dataKey = "data"
    static let messageKey = "msg"
    static let codeKey = "code"
    static let successCode: Int = 101
    static let JsonDecodeErrorCode: Int = 1000000
    static let ConnectionFailureErrorCode: Int = 9999
}


class ResponseModel {
    var code: Int = -999
    var message: String = ""
    var data: String = ""
}

// MARK: - NetWork Request
extension TargetType {

    // MARK: - Single Model Response
    @discardableResult
    func request<T: Mappable>(modelType: T.Type, cacheType: NetworkCacheType = .ignoreCache, showError: Bool = false, successCallback: @escaping RequestModelCallback<T>, failureCallback: RequestFailureCallback? = nil) -> Cancellable? {
        return NetWorkRequest(cacheType: cacheType, showError: showError, successCallback: { responseModel, jsonData in
            if let model = T(JSONString: responseModel.data) {
                successCallback(model, responseModel)
            } else {
                errorHandler(code: responseModel.code, message: "暂无数据", showError: showError, failure: failureCallback)
            }
        }, failureCallback: failureCallback)
    }

    // MARK: - Array Model Response
    @discardableResult
    func request<T: Mappable>(modelType: [T].Type, cacheType: NetworkCacheType = .ignoreCache, showError: Bool = false, successCallback: @escaping RequestModelsCallback<T>, failureCallback: RequestFailureCallback? = nil) -> Cancellable? {
        return NetWorkRequest(cacheType: cacheType, showError: showError, successCallback: { responseModel, jsonData in
            if let model = [T](JSONString: responseModel.data) {
                successCallback(model, responseModel)
            } else {
                errorHandler(code: responseModel.code, message: "暂无数据", showError: showError, failure: failureCallback)
            }
        }, failureCallback: failureCallback)
    }

    // MARK: - Json Response
    @discardableResult
    func defaultRequest(cacheType: NetworkCacheType = .ignoreCache, showError: Bool = false, successCallback: @escaping DefaultSuccessCallback, failureCallback: RequestFailureCallback? = nil) -> Cancellable? {
        return NetWorkRequest(cacheType: cacheType, showError: showError, successCallback: { responseModel, jsonData in
            if let jsonData = jsonData {
                successCallback(jsonData)
            } else {
                errorHandler(code: responseModel.code, message: "暂无数据", showError: showError, failure: failureCallback)
            }
        }, failureCallback: failureCallback)
    }
    
    @discardableResult
    func otherRequest(successCallback: @escaping DefaultSuccessCallback, failureCallback: RequestFailureCallback? = nil) -> Cancellable?  {
        return Network.default.provider.request(MultiTarget(self)) { result in
            switch result {
            case let .success(response):
                do {
                    let jsonData = try JSON(data: response.data)
                    logNetWorkInfo("\(jsonData)")
                    successCallback(jsonData)
                } catch {
                    let model = ResponseModel()
                    model.code = BaseResponseKey.JsonDecodeErrorCode
                    model.message = "数据解析错误"
                    failureCallback?(model)
                }
            case let .failure(error):
                let model = ResponseModel()
                model.code = BaseResponseKey.ConnectionFailureErrorCode
                if let msg = error.errorDescription {
                    model.message = msg
                } else {
                    model.message = "请求失败"
                }
                failureCallback?(model)
            }
        }
    }


    // MARK: - Private Functions
    private func NetWorkRequest(cacheType: NetworkCacheType, showError: Bool = false, successCallback: @escaping RequestBaseCallback, failureCallback: RequestFailureCallback? = nil) -> Cancellable? {
        switch cacheType {
        case .ignoreCache:
            return Network.default.provider.request(MultiTarget(self)) { result in
                switch result {
                case let .success(response):
                    saveCacheResponse(response)
                    processResponseData(successCallback: successCallback, response: response, showError: showError, failureCallback: failureCallback)
                case let .failure(error):
                    errorHandler(code: error.errorCode, message: error.localizedDescription, showError: showError, failure: failureCallback)
                }
            }
        case .cacheElseNetwork:
            if let response = readCacheResponse() {
                processResponseData(successCallback: successCallback, response: response, showError: showError, failureCallback: failureCallback)
            } else {
                return Network.default.provider.request(MultiTarget(self)) { result in
                    switch result {
                    case let .success(response):
                        saveCacheResponse(response)
                        processResponseData(successCallback: successCallback, response: response, showError: showError, failureCallback: failureCallback)
                    case let .failure(error):
                        errorHandler(code: error.errorCode, message: error.localizedDescription, showError: showError, failure: failureCallback)
                    }
                }
            }
        case .networkElseCache:
            return Network.default.provider.request(MultiTarget(self)) { result in
                switch result {
                case let .success(response):
                    saveCacheResponse(response)
                    processResponseData(successCallback: successCallback, response: response, showError: showError, failureCallback: failureCallback)
                case let .failure(error):
                    if let response = self.readCacheResponse() {
                        processResponseData(successCallback: successCallback, response: response, showError: showError, failureCallback: failureCallback)
                    } else {
                        errorHandler(code: error.errorCode, message: error.localizedDescription, showError: showError, failure: failureCallback)
                    }
                }
            }
        case .cacheThenNetwork:
            if let response = readCacheResponse() {
                processResponseData(successCallback: successCallback, response: response, showError: showError, failureCallback: failureCallback)
            }
            return Network.default.provider.request(MultiTarget(self)) { result in
                switch result {
                case let .success(response):
                    saveCacheResponse(response)
                    processResponseData(successCallback: successCallback, response: response, showError: showError, failureCallback: failureCallback)
                case let .failure(error):
                    errorHandler(code: error.errorCode, message: error.localizedDescription, showError: showError, failure: failureCallback)
                }
            }
        }
        return nil
    }


    private func processResponseData(successCallback: @escaping RequestBaseCallback, response: Moya.Response, showError: Bool = false, failureCallback: RequestFailureCallback? = nil) {
        do {
            let jsonData = try JSON(data: response.data)
            logNetWorkInfo("\(jsonData)")
            let respModel = ResponseModel()
            respModel.code = jsonData[BaseResponseKey.codeKey].intValue
            respModel.message = jsonData[BaseResponseKey.messageKey].stringValue
            if respModel.code == BaseResponseKey.successCode {
                respModel.data = jsonData[BaseResponseKey.dataKey].rawString() ?? ""
                successCallback(respModel, jsonData)
            } else {
                errorHandler(code: respModel.code, message: respModel.message, showError: showError, failure: failureCallback)
            }
        } catch {
            errorHandler(code: BaseResponseKey.JsonDecodeErrorCode, message: String(data: response.data, encoding: String.Encoding.utf8)!, showError: showError, failure: failureCallback)
        }
    }

    // MARK: - 错误处理
    private func errorHandler(code: Int, message: String, showError: Bool, failure: RequestFailureCallback?) {
        logger.info("errorHandler：\(code)--\(message)")
        let model = ResponseModel()
        model.code = code
        model.message = message
        if showError {
            if let _ = UIViewController.currentViewController() {
                SVProgressHUD.showError(withStatus: message)
            }
        }
        failure?(model)
    }

    private func logNetWorkInfo(_ response: String) {
        #if DEBUG
        logger.info("\(baseURL)\(path) --- \(method.rawValue) ----> responseData：\(response)")
//        logger.info("\(baseURL)\(path) --- \(method.rawValue)")
        #endif
    }

}

