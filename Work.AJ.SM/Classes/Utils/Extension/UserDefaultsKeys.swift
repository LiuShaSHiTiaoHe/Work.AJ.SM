//
//  UserDefaultsKeys.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var username: DefaultsKey<String?> { .init("username") }
    var userID: DefaultsKey<String?> { .init("userid") }
    var userRealName: DefaultsKey<String?> { .init("userRealName") }

    var currentUnitID: DefaultsKey<Int?> { .init("currentUnitID") }
    
}
