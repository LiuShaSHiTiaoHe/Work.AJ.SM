//
//  Network.Configuration.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation
import Moya
import DeviceKit
import JKSwiftExtension
import KeychainAccess

public extension Network {

    class Configuration {

        public static var `default`: Configuration = {
            let configuration = Configuration()
            configuration.timeoutInterval = 20
            configuration.plugins = []//[NetworkIndicatorPlugin()]
            configuration.replacingTask = { (target: TargetType) -> Task in
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
            configuration.addingHeaders = { (target: TargetType) -> [String: String] in
                let version = Bundle.jk.appVersion
                let identifierID = Keychain.init(service: kKeyChainServiceKey)["xbid"] ?? ""
                let header: Dictionary<String, String> = ["version-code": version,"client-type": kDeviceType, "x-bid": identifierID,"x-device": DeviceManager.shared.requestHeaderXDeviceString()]
                return header
            }
            
            return configuration
        }()//Configuration()

        public var addingHeaders: (TargetType) -> [String: String] = { _ in
            [:]
        }

        public var replacingTask: (TargetType) -> Task = {
            $0.task
        }

        public var timeoutInterval: TimeInterval = 20

        public var plugins: [PluginType] = []

        public init() {
        }
    }
}
