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
        
        public static var `default`: Configuration = Configuration()
        
        public var addingHeaders: (TargetType) -> [String: String] = { _ in [:] }
        
        public var replacingTask: (TargetType) -> Task = { $0.task }
        
        public var timeoutInterval: TimeInterval = 60
        
        public var plugins: [PluginType] = []
        
        public init() {}
    }
}
