//
//  UnitLockModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/29.
//

import Foundation
import RealmSwift

class UnitLockModel: Object, Mappable {
    
    @Persisted var lockcom: String?
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
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "locks") var assignee: LinkingObjects<UnitModel>

    ///reserved value
    @Persisted var reservedString1: String?
    @Persisted var reservedString2: String?
    @Persisted var reservedString3: String?
    @Persisted var reservedString4: String?
    @Persisted var reservedBool1: Bool = false
    @Persisted var reservedBool2: Bool = false
    @Persisted var reservedInt1: Int
    @Persisted var reservedInt2: Int
    
    required convenience init?(map: ObjectMapper.Map) {
      self.init()
    }

    // Mappable
    func mapping(map: ObjectMapper.Map) {
        lockcom <- map["LOCKCOM"]
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
    }
}
