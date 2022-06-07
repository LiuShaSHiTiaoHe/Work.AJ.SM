//
//  String.Extension.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/21.
//

import Foundation
extension String {
    func ajImageUrl() -> String {
        return ud.appHost + "images/" + self
    }
    
    public var aj_isMobileNumber: Bool {
        let rgex = "^1[3456789]\\d{9}$"
        return aj_PredicateValue(rgex: rgex)
    }
    
    public func aj_PredicateValue(rgex: String) -> Bool {
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", rgex)
        return checker.evaluate(with: (self))
    }
}
