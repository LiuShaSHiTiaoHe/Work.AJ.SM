//
//  NComDTU.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/12.
//

import UIKit
import ObjectMapper

class NComDTU: Mappable {
    
    var physicalFloor: String?
    var lockType: String?
    var communityID: Int?
    var lockName: String?
    var rID: Int?
    var blockID: Int?
    var ncomUnitID: String?
    var realFloor: String?
    var lockSN: String?
    var gap: Int?
    var provider: String?
    var signalIntensity: String?
    var cellID: Int?
    var lockMac: String?
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        physicalFloor       <- map["PHYSICALFLOOR"]//物理楼层
        lockType            <- map["LOCKTYPE"]//门禁类型 B:蓝牙 W:云对讲
        communityID         <- map["COMMUNITYID"]//小区ID
        lockName            <- map["LOCKNAME"]//设备名称
        rID                 <- map["RID"]//门锁表ID
        blockID             <- map["BLOCKID"]//楼栋ID
        ncomUnitID          <- map["NCOMUNITID"]//所属n方对讲房间id
        realFloor           <- map["REALFLOOR"]//实际楼层;
        lockSN              <- map["LOCKSN"]//门禁设备的序列号
        gap                 <- map["GAP"]//在线状态(1在线，0离线) 默认三分钟无心跳离线
        provider            <- map["PROVIDER"]//厂家:A J;SMY;JB
        signalIntensity     <- map["SIGNALINTENSITY"]//信号强度(0-4)
        cellID              <- map["CELLID"]//单元id
        lockMac             <- map["LOCKMAC"]//mac地址
    }
}
