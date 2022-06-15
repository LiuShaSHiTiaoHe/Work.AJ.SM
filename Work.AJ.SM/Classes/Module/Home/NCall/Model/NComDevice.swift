//
//  NComDevice.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/12.
//

import UIKit
import ObjectMapper

class NComDevice: Mappable {
    
    var locationID: Int?
    var locationName: String?
    var mobile: String?
    var ncomID: Int?
    var status: Bool?
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        locationID          <- map["location_id"]
        locationName        <- map["location_name"]
        mobile              <- map["mobilephone"]
        ncomID              <- map["ncomId"]
        status              <- map["status"]
    }
}
