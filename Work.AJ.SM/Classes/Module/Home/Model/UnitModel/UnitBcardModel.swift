//
//  UnitBcardModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/29.
//

import UIKit

class UnitBcardModel: Mappable {
    
    var sex: String?
    var activation: String?
    var credate: Int?
    var idcard: String?
    var unitid: Int?
    var cellid: Int?
    var jjmoblie: String?
    var gzdw: String?
    var cardtype: String?
    var enddate: Int?
    var picurl: String?
    var ownerid: Int?
    var xzdz: String?
    var mobile: String?
    var cardno: String?
    var communityid: Int?
    var username: String?
    var sqr: String?
    var hjdz: String?
    var userid: Int?
    var type: String?
    var unitno: String?
    var gj : String?
    var mz: String?
    var idname: String?
    var blockid: Int?
    var birthdate: String?
    
    required init?(map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
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
