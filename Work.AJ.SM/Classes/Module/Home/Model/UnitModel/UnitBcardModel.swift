//
//  UnitBcardModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/29.
//

import UIKit
import RealmSwift

class UnitBcardModel: Object, Mappable {
    
    @Persisted var sex: String?
    @Persisted var activation: String?
    @Persisted var credate: Int?
    @Persisted var idcard: String?
    @Persisted var unitid: Int?
    @Persisted var cellid: Int?
    @Persisted var jjmoblie: String?
    @Persisted var gzdw: String?
    @Persisted var cardtype: String?
    @Persisted var enddate: Int?
    @Persisted var picurl: String?
    @Persisted var ownerid: Int?
    @Persisted var xzdz: String?
    @Persisted var mobile: String?
    @Persisted var cardno: String?
    @Persisted var communityid: Int?
    @Persisted var username: String?
    @Persisted var sqr: String?
    @Persisted var hjdz: String?
    @Persisted var userid: Int?
    @Persisted var type: String?
    @Persisted var unitno: String?
    @Persisted var gj : String?
    @Persisted var mz: String?
    @Persisted var idname: String?
    @Persisted var blockid: Int?
    @Persisted var birthdate: String?
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "bcards") var assignee: LinkingObjects<UnitModel>
    required convenience init?(map: ObjectMapper.Map) {
      self.init()
    }

    // Mappable
    func mapping(map: ObjectMapper.Map) {
        sex <- map["SEX"]
        activation <- map["ACTIVATION"]
        credate <- map["CREDATE"]
        idcard <- map["IDCARD"]
        unitid <- map["UNITID"]
        cellid <- map["CELLID"]
        jjmoblie <- map["JJMOBLIE"]
        gzdw <- map["GZDW"]
        cardtype <- map["CARDTYPE"]
        enddate <- map["ENDDATE"]
        picurl <- map["PICURL"]
        ownerid <- map["OWNERID"]
        xzdz <- map["XZDZ"]
        mobile <- map["MOBILE"]
        cardno <- map["CARDNO"]
        communityid <- map["COMMUNITYID"]
        username <- map["USERNAME"]
        hjdz <- map["HJDZ"]
        sqr <- map["SQR"]
        userid <- map["USERID"]
        type <- map["TYPE"]
        unitno <- map["UNITNO"]
        gj <- map["GJ"]
        mz <- map["MZ"]
        idname <- map["IDNAME"]
        blockid <- map["BLOCKID"]
        birthdate <- map["BIRTHDATE"]
    }
}
