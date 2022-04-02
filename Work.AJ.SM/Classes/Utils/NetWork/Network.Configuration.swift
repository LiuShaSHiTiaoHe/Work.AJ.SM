//
//  Network.Configuration.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import Moya

public extension Network {
    
    class Configuration {

        public static var `default`: Configuration = {
            let cofig = Configuration()
            cofig.timeoutInterval = 10
            cofig.plugins = []//[NetworkIndicatorPlugin()]
            cofig.replacingTask = { (target: TargetType) -> Task in
                let url = target.baseURL.absoluteString + target.path
                var task = target.task
                switch task {
                case .requestParameters(let parameters, let encoding):
                    if parameters.has("ekey"), let eValue = parameters["ekey"] as? String {
                        let eParameters = GDataManager.shared.headerMD5(parameters, eValue)
                        task = .requestParameters(parameters: eParameters, encoding: encoding)
                    }
                case .uploadCompositeMultipart(let datas, let parameters):
                    if parameters.has("ekey"), let eValue = parameters["ekey"] as? String {
                        let eParameters = GDataManager.shared.headerMD5(parameters, eValue)
                        task = .uploadCompositeMultipart(datas, urlParameters: eParameters)
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
            return cofig
        }()//Configuration()
        
        public var addingHeaders: (TargetType) -> [String: String] = { _ in [:] }
        
        public var replacingTask: (TargetType) -> Task = { $0.task }
        
        public var timeoutInterval: TimeInterval = 60
        
        public var plugins: [PluginType] = []
        
        public init() {}
    }
}
