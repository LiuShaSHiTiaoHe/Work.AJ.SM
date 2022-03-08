//
//  CommunityModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/8.
//

import UIKit
import ObjectMapper

class CommunityModel: Mappable {

    var name: String?
    var address: String?
    var province: String?
    var phone: String?
    var lng: String?
    var lat: String?
    var rid: Int?
    var city: String?
    var contact: String?

    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        name            <- map["COMMUNITYNAME"]
        address         <- map["ADDRESS"]
        province        <- map["PROVINCE"]
        phone           <- map["PHONE"]
        lng             <- map["LNG"]
        lat             <- map["LAT"]
        rid             <- map["RID"]
        city            <- map["CITY"]
        contact         <- map["CONTACT"]
    }
}
