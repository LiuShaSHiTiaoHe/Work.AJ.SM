//
//  UnitLockModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/29.
//

import Foundation

class UnitLockModel: Mappable {
    
    var lockcom: String?
    var credate: Int?
    var locktype: String?
    var lockmac: String?
    var resetflag: String?
    var cellid: Int?
    var function: String?
    var iscall: Int?
    var realfloor: String?
    var lockkey: String?
    var physicalfloor: String?
    var functionname: String?
    var provider: String?
    var districtid: String?
    var lockname: String?
    var lastconnecttime: Int?
    var communityid: Int?
    var size: String?
    var locksn: String?
    var lockposition: String?
    var blockid: Int?
    var ifon: String?
    
    
    required init?(map: ObjectMapper.Map) {}
    
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
