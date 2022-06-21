//
//  AGEError.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/26.
//

import UIKit

struct AGEError: Error {
    enum ErrorType {
        case fail(String)
        case invalidParameter(String)
        case valueNil(String)
        case unknown
    }
    
    var localizedDescription: String {
        switch type {
        case .fail(let reason):             return "\(reason)"
        case .invalidParameter(let para):   return "\(para)"
        case .valueNil(let para):           return "\(para) nil"
        case .unknown:                      return "unknown error"
        }
    }
    
    var type: ErrorType
}
