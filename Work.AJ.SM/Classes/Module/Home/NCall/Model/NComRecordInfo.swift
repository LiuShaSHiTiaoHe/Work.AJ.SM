//
//  NComRecordInfo.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/12.
//

import UIKit
import ObjectMapper

class NComRecordInfo: Mappable {
    var uniqueCode: String?
    var communityID: Int?
    var unitID: Int?
    var callSource: String?
    var callTarget: String?
    var callType: Int?
    var dtuNickName: String?
    var userName: String?
    var callStatus: Int?
    var askCallTime: String?
    var failCallTime: String?
    var answerCallTime: String?
    var endCallTime: String?
    var callAllTime: Int?
    var communityName: String?
    var unitNo: String?
    var unitName: String?
    var blockName: String?
    var cellNo: String?
    var cellName: String?

    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        uniqueCode              <- map["UNIQUECODE"]
        communityID             <- map["COMMUNITYID"]
        unitID                  <- map["UNITID"]
        callSource              <- map["CALLSOURCE"]
        callTarget              <- map["CALLTARGET"]
        callType                <- map["CALLTYPE"]
        dtuNickName             <- map["DTUNICKNAME"]
        userName                <- map["USERNAME"]
        callStatus              <- map["CALLSTATUS"]
        askCallTime             <- map["ASKCALLTIME"]
        failCallTime            <- map["FAILCALLTIME"]
        answerCallTime          <- map["ANSWERCALLTIME"]
        endCallTime             <- map["ENDCALLTIME"]
        callAllTime             <- map["CALLALLTIME"]
        communityName           <- map["COMMUNITYNAME"]
        unitNo                  <- map["UNITNO"]
        unitName                <- map["UNITNAME"]
        blockName               <- map["BLOCKNAME"]
        cellNo                  <- map["CELLNO"]
        cellName                <- map["CELLNAME"]
    }
}
