//
//  UnitLockModel.swift
//  SmartCommunity
//
//  Created by Anjie on 2021/12/29.
//

import Foundation
import RealmSwift

class UnitLockModel: Object, Mappable {
    
    @Persisted var lockcom: String?
    @Persisted var lockID: Int?
    @Persisted var credate: Int?
    @Persisted var locktype: String?//W门口机 B蓝牙
    @Persisted var lockmac: String?//门口机mac值（开门用到）
    @Persisted var resetflag: String?
    @Persisted var cellid: Int?
    @Persisted var function: String?
    @Persisted var iscall: Int?
    @Persisted var realfloor: String?
    @Persisted var lockkey: String?
    @Persisted var physicalfloor: String?
    @Persisted var functionname: String?
    @Persisted var provider: String?
    @Persisted var districtid: String?
    @Persisted var lockname: String?//门口机名称
    @Persisted var lastconnecttime: Int?
    @Persisted var communityid: Int?
    @Persisted var size: String?
    @Persisted var locksn: String?
    @Persisted var lockposition: String?
    @Persisted var blockid: Int?
    @Persisted var ifon: String?
    @Persisted var gap: String?// T在线  F不在线
    @Persisted var lockLocation: String?//G:大门 B:楼栋 C:单元
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "locks") var assignee: LinkingObjects<UnitModel>

    ///reserved value
    @Persisted var stringValue1: String?
    @Persisted var stringValue2: String?
    @Persisted var stringValue3: String?
    @Persisted var stringValue4: String?
    @Persisted var stringValue5: String?
    @Persisted var stringValue6: String?
    @Persisted var boolValue1: Bool?
    @Persisted var boolValue2: Bool?
    @Persisted var boolValue3: Bool?
    @Persisted var boolValue4: Bool?
    @Persisted var intValue1: Int?
    @Persisted var intValue2: Int?
    @Persisted var intValue3: Int?
    @Persisted var intValue4: Int?
    
    required convenience init?(map: ObjectMapper.Map) {
      self.init()
    }

    // Mappable
    func mapping(map: ObjectMapper.Map) {
        lockcom <- map["LOCKCOM"]
        lockID <- map["LOCKID"]
        credate <- map["CREDATE"]
        locktype <- map["LOCKTYPE"]
        lockmac <- map["LOCKMAC"]
        resetflag <- map["RESETFLAG"]
        cellid <- map["CELLID"]
        function <- map["FUNCTION"]
        iscall <- map["ISCALL"]
        realfloor <- map["REALFLOOR"]
        lockkey <- map["LOCKKEY"]
        physicalfloor <- map["PHYSICALFLOOR"]
        functionname <- map["FUNCTIONNAME"]
        provider <- map["PROVIDER"]
        districtid <- map["DISTRICTID"]
        lockname <- map["LOCKNAME"]
        lastconnecttime <- map["LASTCONNECTTIME"]
        communityid <- map["COMMUNITYID"]
        size <- map["SIZE"]
        locksn <- map["LOCKSN"]
        lockposition <- map["LOCKPOSITION"]
        blockid <- map["BLOCKID"]
        ifon <- map["IFON"]
        gap <- map["GAP"]
        lockLocation <- map["LOCKPOSITION"]
    }
}
