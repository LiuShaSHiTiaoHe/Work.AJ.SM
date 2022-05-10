//
//  PropertyContactModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/10.
//

import UIKit
import ObjectMapper

class PropertyContactModel: Mappable {
    
    var communityID: Int?
    var department: String?
    var rid: Int?
    var mobile: String?

    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        communityID <- map["COMMUNITYID"]
        department <- map["DEPARTMENT"]
        rid <- map["RID"]
        mobile <- map["TEL"]
    }
    
}
