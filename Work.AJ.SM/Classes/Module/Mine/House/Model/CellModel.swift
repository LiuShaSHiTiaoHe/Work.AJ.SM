//
//  CellModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/9.
//

import UIKit
import ObjectMapper

class CellModel: Mappable {
    var cellMM: String?
    var communityID: Int?
    var cellID: Int?
    var cretime: String?
    var rid: Int?
    var cellNO: String?
    var cellName: String?
    var blockID: Int?

    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        cellMM              <- map["CELLMM"]
        communityID         <- map["COMMUNITYID"]
        cellID              <- map["CELLID"]
        cretime             <- map["CRETIME"]
        rid                 <- map["RID"]
        cellNO              <- map["CELLNO"]
        cellName            <- map["CELLNAME"]
        blockID             <- map["BLOCKID"]
    }
}
