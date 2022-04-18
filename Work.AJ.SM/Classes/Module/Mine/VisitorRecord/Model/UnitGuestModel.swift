//
//  UnitGuestModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/18.
//

import UIKit
import ObjectMapper

class UnitGuestModel: Mappable {
    var password: String?
    var status: String?//O:未取消   C:已取消
    var startdate: Int?
    var guesttype: String?
    var passtype: String?//T为多次有效，F为1次有效
    var unitid: Int?
    var phone: String?
    var communityid: Int?
    var credate: Int?
    var enddate: Int?
    var rid: Int?
    var userid: Int?
        
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
    }
    

}
