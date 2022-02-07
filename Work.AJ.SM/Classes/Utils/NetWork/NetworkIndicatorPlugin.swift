//
//  NetworkIndicatorPlugin.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import Moya
import SVProgressHUD

public final class NetworkIndicatorPlugin: PluginType {
    
    private static var numberOfRequests: Int = 0 {
        didSet {
            if numberOfRequests > 1 { return }
            DispatchQueue.main.async {
                if self.numberOfRequests > 0 {
                    SVProgressHUD.show()
                }else{
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    public init() {}
    
    public func willSend(_ request: RequestType, target: TargetType) {
        NetworkIndicatorPlugin.numberOfRequests += 1
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        NetworkIndicatorPlugin.numberOfRequests -= 1
        switch result {
        case .success(let response):
            do{
                let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers)
                if let dictionaryFromJson = json as? Dictionary<String, Any> {
                    logger.info("response: \(dictionaryFromJson)")
                }
            } catch {
                logger.error("JSONSerialization catch error \(error)")
            }
        case .failure(let error):
            logger.error("\(error.localizedDescription)")
        }
    }
}
