//
//  UserUnitModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/10.
//

import UIKit
import ObjectMapper

class UserUnitModel: Mappable {
    var credate: Int?
    var unitType: String?
    var state: String?
    var physicalFloor: String?
    var rid: Int?
    var unitArea: Int?
    var showFloorIndex: String?
    var cellID: Int?
    var cellName: String?
    var doorSide: String?
    var blockID: Int?
    var unitNO: String?
    var communityID: Int?
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        credate             <- map["CREDATE"]
        unitType            <- map["UNITTYPE"]
        state               <- map["STATE"]
        physicalFloor       <- map["PHYSICALFLOOR"]
        rid                 <- map["RID"]
        unitArea            <- map["UNITAREA"]
        showFloorIndex      <- map["SHOWFLOORINDEX"]
        cellID              <- map["CELLID"]
        cellName            <- map["CELLNAME"]
        doorSide            <- map["DOORSIDE"]
        blockID             <- map["BLOCKID"]
        unitNO              <- map["UNITNO"]
        communityID         <- map["COMMUNITYID"]
    }
}
