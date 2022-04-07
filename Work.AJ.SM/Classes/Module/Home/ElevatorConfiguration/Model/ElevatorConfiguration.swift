//
//  ElevatorConfiguration.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/7.
//

import UIKit
import ObjectMapper

class ElevatorConfiguration: Mappable {
    var blocks: [ConfigurationBlock]?
    var communityConfig: ConfigurationCommunity?
    var showFloors: [ConfigurationShowFloor]?
    
    func mapping(map: ObjectMapper.Map) {
        blocks <- map["blocks"]
        communityConfig <- map["communityConfig"]
        showFloors <- map["showFloors"]
    }
    
    required init?(map: ObjectMapper.Map) {}
}

class ConfigurationBlock: Mappable {
    var credate: Int?
    var rid: Int?
    var creby: String?
    var cellreqd: String?
    var cells: [ConfigurationCell]?
    var blockname: String?
    var state: String?
    var communityid: Int?
    var blockno: String?
    var districtid: Int?
    var blockid: Int?
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        credate <- map["CREDATE"]
        rid <- map["RID"]
        creby <- map["CREBY"]
        cellreqd <- map["CELLREQD"]
        cells <- map["cells"]
        blockname <- map["BLOCKNAME"]
        state <- map["STATE"]
        communityid <- map["COMMUNITYID"]
        blockno <- map["BLOCKNO"]
        districtid <- map["DISTRICTID"]
        blockid <- map["BLOCKID"]
    }
    
}

class ConfigurationCell: Mappable {
    var cretime: String?
    var cellno: String?
    var cellLiftGroups: [ConfigurationCellLiftGroup]?
    var communityid: Int?
    var rid: Int?
    var cellmm: String?
    var blockid: Int?
    var cellid: Int?
    var cellname: String?
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        cretime <- map["CRETIME"]
        cellno <- map["CELLNO"]
        cellLiftGroups <- map["cellLiftGroups"]
        communityid <- map["COMMUNITYID"]
        rid <- map["RID"]
        cellmm <- map["CELLMM"]
        blockid <- map["BLOCKID"]
        cellid <- map["CELLID"]
        cellname <- map["CELLNAME"]
    }
}

class ConfigurationCellLiftGroup: Mappable {
    var communitygroupid: Int?
    var lifts: [ConfigurationLifts]?
    var groupid: Int?
    var cellid: Int?
    var groupname: String?
    var communityid: Int?
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        communitygroupid <- map["COMMUNITYGROUPID"]
        lifts <- map["lifts"]
        groupid <- map["GROUPID"]
        cellid <- map["CELLID"]
        groupname <- map["GROUPNAME"]
        communityid <- map["COMMUNITYID"]
    }
}

class ConfigurationLifts: Mappable {
    var config: String?
    var cellGroupID: Int?//电梯单元群组id
    var groupID: Int?//电梯id
    var liftSN: String?//电梯SN码
    /*
    单开门：
        物理楼层1#显示楼层序号1#A门是否可控（1可控、0不可控）&物理楼层2#显示楼层序号2#A门是否可控(1可控、0不可控)
    贯穿门：
        物理楼层1#显示楼层序号1#A门是否可控（1可控、0不可控）#B门是否可控（1可控、0不可控）&物理楼层2#显示楼层序号2#A门是否可控#B门是否可控(1可控、0不可控)
     "1#1#1&2#2#0&3#3#1&4#4#1&5#5#1&6#6#1&7#7#1&8#8#1"
     */
    var elevatorFloorConfig: String?//电梯楼层配置信息
    var groupIDMM: String?
    var projectGroupID: Int?
    var rID: Int?
    var publicFloorConfig: String?
    var remark: String?
    var doorType: Int?//电梯门类型（1单开门、2贯穿门）
    var mac: String?

    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        config <- map["CONFIG"]
        cellGroupID <- map["CELL_GROUP_ID"]
        groupID <- map["GROUPID"]
        liftSN <- map["LIFT_SN"]
        elevatorFloorConfig <- map["ELEVATOR_FLOOR_CONFIG"]
        groupIDMM <- map["GROUPIDMM"]
        projectGroupID <- map["PROJECT_GROUPID"]
        rID <- map["RID"]
        publicFloorConfig <- map["PUBLIC_FLOOR_CONFIG"]
        remark <- map["REMARK"]
        doorType <- map["DOOR_TYPE"]
        mac <- map["MAC"]
    }
}

// MARK: - ShowFloors
class ConfigurationShowFloor: Mappable {
    var communityid, increaseid: Int?
    var showfloor: String?
    
    func mapping(map: ObjectMapper.Map) {
        communityid <- map["COMMUNITYID"]
        increaseid <- map["INCREASEID"]
        showfloor <- map["SHOWFLOOR"]
    }
    
    required init?(map: ObjectMapper.Map) {}
}

// MARK: - communityConfig
class ConfigurationCommunity: Mappable {
    var useBlocks: String?
    var blockSecret: String?
    
    func mapping(map: ObjectMapper.Map) {
        useBlocks <- map["USE_BLOCKS"]
        blockSecret <- map["BLOCK_SECRET"]
    }
    
    required init?(map: ObjectMapper.Map) {}
}


