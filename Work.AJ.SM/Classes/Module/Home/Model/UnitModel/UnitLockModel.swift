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
    @Persisted var locktype: String?
    @Persisted var lockmac: String?
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
    @Persisted var lockname: String?
    @Persisted var lastconnecttime: Int?
    @Persisted var communityid: Int?
    @Persisted var size: String?
    @Persisted var locksn: String?
    @Persisted var lockposition: String?
    @Persisted var blockid: Int?
    @Persisted var ifon: String?
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "locks") var assignee: LinkingObjects<UnitModel>

    
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
    }
}
