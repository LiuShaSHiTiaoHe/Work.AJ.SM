//
//  APIs.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
final class APIs {
    
    static let baseUrl = host + servicePath
    //MARK: 房屋
    static let userUnit = "appcity/getMyUnit.do"
    static let allCity = "appcity/getCity.do"
    static let userCommunity = "appcity/getCommunity.do"
    static let userBlock = "appcity/getBlock.do"
    static let userCell = "appcity/getCell.do"
    static let allUnit = "appcity/getUnit.do"
    static let deleteUserUnit = "appcity/deleteMyUnit.do"
    static let userAuthentication = "appcity/authentication.do"
    
    static let notice = "appcity/getNotice.do"
    static let advertisement = "appcity/getAdByPosition.do"
    
}
