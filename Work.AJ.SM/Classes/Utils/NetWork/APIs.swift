//
//  APIs.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
final class APIs {
    
    static let baseUrl = host + servicePath
    //MARK: 用户鉴权
    static let login = "appcity/login.do"
    static let regist = "appcity/register.do"
    static let editPassword = "appcity/editPassword.do"
    static let msgCode = "appcity/getMessageCode.do"
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
    //根据单元电梯群组获取电梯
    static let cellGroupElevators = "appcity/getLiftByCellGroup"
    
    static let locks = "appcity/getLock.do"
    
    //获取二维码信息
    static let userQRCode = "appcity/createOfflineQrcode"

}
