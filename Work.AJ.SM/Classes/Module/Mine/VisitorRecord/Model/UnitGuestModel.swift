//
//  UnitGuestModel.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/18.
//

import UIKit
import ObjectMapper

class UnitGuestModel: Mappable {
    var password: String?//密码。GUESTTYPE=1秘钥，GUESTTYPE=2二维码
    var status: String?//O:未取消   C:已取消
    var startdate: String? //"2019-06-24 13:49:03"
    var guesttype: String?//访客类型。“1”：密码；“2”：二维码
    var passtype: String?//T为多次有效，F为1次有效
    var unitid: Int?
    var phone: String?
    var communityid: Int?
    var credate: String?
    var enddate: String?
    var rid: Int?
    var userid: Int?
    var valid: Int?//0无效，1有效
        
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        password <- map["PASSWORD"]
        status <- map["STATUE"]
        startdate <- map["STARTDATE"]
        guesttype <- map["GUESTTYPE"]
        passtype <- map["PASSTYPE"]
        unitid <- map["UNITID"]
        phone <- map["PHONE"]
        communityid <- map["COMMUNITYID"]
        userid <- map["USERID"]
        rid <- map["RID"]
        credate <- map["CREDATE"]
        enddate <- map["ENDDATE"]
        valid <- map["vaild"]
    }
    

}
