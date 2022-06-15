//
//  MemberModel.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/24.
//

import UIKit
import ObjectMapper

class MemberModel: Mappable {

    var startDate: String?  //访客|租约起始时间
    var realName: String?
    var unitID: Int?
    var communityID: Int?
    var state: String?   //P:待审核 N:正常 H:失效（禁止开锁） E:过期(租约|访客到期)
    var blockID: Int?
    var rID: Int?
    var mac: String?
    var endDate: String?
    var auditDate: Int?
    var userType: String?  //O:业主 F:家属 R:租客
    var userID: Int?
    var userName: String?
    var defaultFlag: String?
    var mobile: String?
    var creDate: Int?

    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        startDate       <- map["STARTDATE"]
        realName        <- map["REALNAME"]
        unitID          <- map["UNITID"]
        communityID     <- map["COMMUNITYID"]
        state           <- map["STATE"]
        blockID         <- map["BLOCKID"]
        rID             <- map["RID"]
        mac             <- map["MAC"]
        endDate         <- map["ENDDATE"]
        auditDate       <- map["AUDITDATE"]
        userType        <- map["USERTYPE"]
        userID          <- map["USERID"]
        userName        <- map["USERNAME"]
        defaultFlag     <- map["DEFAULTFLAG"]
        mobile          <- map["MOBILE"]
        creDate         <- map["CREDATE"]
    }
}
