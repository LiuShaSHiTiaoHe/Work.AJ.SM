//
//  BlockModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/8.
//

import UIKit
import ObjectMapper

class BlockModel: Mappable {
    var credate: String?
    var communityID: Int?
    var rid: Int?
    var blockno: String?
    var blockName: String?
    var creby: String?
    var districtID: String?
    var cellreqd: String?

    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        credate             <- map["CREDATE"]
        communityID         <- map["COMMUNITYID"]
        rid                 <- map["RID"]
        blockno             <- map["BLOCKNO"]
        blockName           <- map["BLOCKNAME"]
        creby               <- map["CREBY"]
        districtID          <- map["DISTRICTID"]
        cellreqd            <- map["CELLREQD"]
    }
}
