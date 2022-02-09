//
//  UnitCodesModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/29.
//

import UIKit

class UnitCodesModel: Mappable {
    
    var communityid: Int?
    var showfloor: String?
    var increaseid: Int?
    
    required init?(map: ObjectMapper.Map) {}
    
    // Mappable
    func mapping(map: ObjectMapper.Map) {
        communityid <- map["COMMUNITYID"]
        showfloor <- map["SHOWFLOOR"]
        increaseid <- map["INCREASEID"]
    }
}
