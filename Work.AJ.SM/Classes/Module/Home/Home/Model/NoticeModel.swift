//
//  NoticeModel.swift
//  SmartCommunity
//
//  Created by Anjie on 2021/12/30.
//

import UIKit

class NoticeModel: Mappable {

    var communityid: String?
    var creby: String?
    var crebyname: String?
    var credate: String?
    var noticetitle: String?
    var remark: String?
    var rid: String?
    var username: String?

    required init?(map: ObjectMapper.Map) {
    }

    func mapping(map: ObjectMapper.Map) {
        communityid <- map["COMMUNITYID"]
        creby <- map["CREBY"]
        crebyname <- map["CREBYNAME"]
        credate <- map["CREDATE"]
        noticetitle <- map["NOTICETITLE"]
        remark <- map["REMARK"]
        rid <- map["RID"]
        username <- map["USERNAME"]
    }


}
