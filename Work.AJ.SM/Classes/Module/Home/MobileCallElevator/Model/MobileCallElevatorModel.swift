//
//  MobileCallElevatorModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/17.
//

import Foundation
import ObjectMapper

class MobileCallElevatorModel: Mappable {

    var unit: UnitElevatorModel?
    var showFloors: [FloorInfo]?
    var lifts: [ElevatorInfo]?

    required init?(map: ObjectMapper.Map) {
    }

    func mapping(map: ObjectMapper.Map) {
        unit <- map["unit"]
        showFloors <- map["showFloors"]
        lifts <- map["lifts"]

    }
}

class UnitElevatorModel: Mappable {
    var doorSide: String?
    var showFloor: String?
    var showFloorIndex: Int?
    var callNO: String?
    var physicalFloor: String?
    var otherUsed: String?
    var communityID: Int?
    var cellID: Int?
    var blockID: Int?
    var unitNO: String?

    required init?(map: ObjectMapper.Map) {
    }

    func mapping(map: ObjectMapper.Map) {
        doorSide <- map["DOORSIDE"]
        showFloor <- map["SHOWFLOOR"]
        showFloorIndex <- map["SHOWFLOORINDEX"]
        callNO <- map["CALLNO"]
        physicalFloor <- map["PHYSICALFLOOR"]
        otherUsed <- map["OTHERUSED"]
        communityID <- map["COMMUNITYID"]
        cellID <- map["CELLID"]
        blockID <- map["BLOCKID"]
        unitNO <- map["UNITNO"]
    }
}

class FloorInfo: Mappable {

    var communityID: Int?
    var showFloor: String?
    var increaseID: Int?

    required init?(map: ObjectMapper.Map) {
    }

    func mapping(map: ObjectMapper.Map) {
        communityID <- map["COMMUNITYID"]
        showFloor <- map["SHOWFLOOR"]
        increaseID <- map["INCREASEID"]
    }
}

class ElevatorInfo: Mappable {

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

    required init?(map: ObjectMapper.Map) {
    }

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

class FloorMapInfo {
    var increasID: String? //显示楼层对应的自增字符
    var physicalFloor: String?//物理楼层
    var showFloor: String?//显示楼层
    var doorType: String?//电梯门类型  1单开门  2贯穿门
    var controlA: String?//A门是否受控（1受控，0不受控）
    var controlB: String?//B门是否受控（1受控，0不受控，单开门
}


class FloorInfoMappable: Mappable {

    var increasID: String? //显示楼层对应的自增字符
    var physicalFloor: String?//物理楼层
    var showFloor: String?//显示楼层
    var doorType: String?//电梯门类型  1单开门  2贯穿门
    var controlA: String?//A门是否受控（1受控，0不受控）
    var controlB: String?//B门是否受控（1受控，0不受控，单开门

    required init?(map: ObjectMapper.Map) {
    }

    func mapping(map: ObjectMapper.Map) {
        increasID <- map["INCREASEID"]
        physicalFloor <- map["PHYSICALFLOOR"]
        showFloor <- map["SHOWFLOOR"]
        doorType <- map["doorType"]
        controlA <- map["CONTROLA"]
        controlB <- map["CONTROLB"]
    }
}
