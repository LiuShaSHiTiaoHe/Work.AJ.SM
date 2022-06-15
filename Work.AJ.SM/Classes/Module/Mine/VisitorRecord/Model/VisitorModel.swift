//
//  VisitorModel.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/29.
//

import UIKit
import ObjectMapper

class VisitorModel: Mappable {
    
    var communityid: Int?
    var credate: String?
    var enddate: String?
    var passtype: String?//T为多次有效，F为1次有效
    var password: String?
    var phone: String?
    var rid: String?
    var status: String?//O:未取消   C:已取消
    var unitid: Int?
    var userid: Int?
        
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        communityid <- map["COMMUNITYID"]
        credate <- map["CREDATE"]
        enddate <- map["ENDDATE"]
        passtype <- map["PASSTYPE"]
        password <- map["PASSWORD"]
        phone <- map["PHONE"]
        rid <- map["RID"]
        status <- map["STATUE"]
        unitid <- map["UNITID"]
        userid <- map["USERID"]
    }
    

}
