//
//  UnitModel.swift
//  SmartCommunity
//
//  Created by Anjie on 2021/12/29.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class UnitModel: Object, Mappable  {
    
    //MYSET1    人脸识别
    //MYSET2    户户通
    //MYSET3    激活蓝牙卡
    //MYSET4    消息
    //MYSET5    通行记录
    //MYSET6    开门方式设置
    //MYSET7    开门密码
    //MYSET8    允许访客呼叫到手机
    //MYSET9    呼叫物业
    //MYSET10    我的房屋
    //MYSET11    成员管理
    //MYSET12    设置
    
    //1:标识为n方对讲房间 非1:非n方对讲房间
    //模块化设置 MOUDLE1-MOUDLE10
    
    @Persisted var moudle1: String?
    @Persisted var moudle2: String?
    @Persisted var moudle3: String?
    @Persisted var moudle4: String?
    @Persisted var moudle5: String?
    @Persisted var moudle6: String?
    @Persisted var moudle7: String?
    @Persisted var moudle8: String?
    @Persisted var moudle9: String?
    @Persisted var moudle10: String?
    @Persisted var moudle11: String?
    @Persisted var moudle12: String?
    @Persisted var moudle13: String?
    @Persisted var moudle14: String?
    @Persisted var moudle15: String?
    @Persisted var moudle16: String?
    @Persisted var moudle17: String?
    //moudle18 门禁对讲 moudle2 改名为远程开门
    @Persisted var moudle18: String?

    @Persisted var myset1: String?
    @Persisted var myset2: String?
    @Persisted var myset3: String?
    @Persisted var myset4: String?
    @Persisted var myset5: String?
    @Persisted var myset6: String?
    @Persisted var myset7: String?
    @Persisted var myset8: String?
    @Persisted var myset9: String?
    @Persisted var myset10: String?
    @Persisted var myset11: String?
    @Persisted var myset12: String?
    
    @Persisted var state: String?
    @Persisted var enddate: String?
    @Persisted var communityname: String?
    @Persisted var auditdate: Int?
    @Persisted var codes: List<UnitCodesModel>
    @Persisted var unitid: Int?
    @Persisted var defaultflag: String?
    @Persisted var cellno: String?
    @Persisted var bcards: List<UnitBcardModel>
    @Persisted var operid: Int?
    @Persisted var mobile: String?
    @Persisted var rid: Int?
    @Persisted var blockid: Int?
    @Persisted var mac: String?
    @Persisted var unitno: String?
    @Persisted var buttons: List<UnitButtonsModel>
    @Persisted var mgruserid: Int?
    @Persisted var credate: Int?
    @Persisted var unitarea: Int?
    @Persisted var startdate: String?
    @Persisted var blockname: String?
    @Persisted var sortbar: String?
    @Persisted var callorderstr: String?
    @Persisted var otherused: Int?
    @Persisted var cellmm: String?
    @Persisted var usertype: String?
    @Persisted var logintoken: String?
    @Persisted var blockno: String?
    @Persisted var ismgr: Bool?
    @Persisted var rentername: String?
    @Persisted var renterid: String?
    @Persisted var doorside: String?
    @Persisted var communityid: Int?
    @Persisted var locks: List<UnitLockModel>
    @Persisted var userid: Int?
    @Persisted var cellname: String?
    @Persisted var cellid: Int?
    @Persisted var physicalfloor: String?
    
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
    
    override class func primaryKey() -> String? {
      return "unitid"
    }
    
    // Mappable
    func mapping(map: ObjectMapper.Map) {
        myset4 <- map["MYSET4"]
        moudle12 <- map["MOUDLE12"]
        myset6 <- map["MYSET6"]
        state <- map["STATE"]// N 已审核  P审核中
        moudle13 <- map["MOUDLE13"]
        myset8 <- map["MYSET8"]
        moudle6 <- map["MOUDLE6"]
        moudle14 <- map["MOUDLE14"]
        moudle7 <- map["MOUDLE7"]
        moudle8 <- map["MOUDLE8"]
        moudle15 <- map["MOUDLE15"]
        moudle9 <- map["MOUDLE9"]
        moudle5 <- map["MOUDLE5"]
        enddate <- map["ENDDATE"]
        communityname <- map["COMMUNITYNAME"]
        auditdate <- map["AUDITDATE"]
        codes <- (map["CODES"], ListTransform<UnitCodesModel>())
        unitid <- map["UNITID"]
        defaultflag <- map["DEFAULTFLAG"]
        myset10 <- map["MYSET10"]
        myset11 <- map["MYSET11"]
        myset12 <- map["MYSET12"]
        cellno <- map["CELLNO"]
        bcards <- (map["BCARDS"], ListTransform<UnitBcardModel>())
        operid <- map["OPERID"]
        mobile <- map["MOBILE"]
        rid <- map["RID"]
        blockid <- map["BLOCKID"]
        mac <- map["MAC"]
        unitno <- map["UNITNO"]
        myset1 <- map["MYSET1"]
        myset3 <- map["MYSET3"]
        buttons <- (map["BUTTONS"], ListTransform<UnitButtonsModel>())
        myset5 <- map["MYSET5"]
        myset7 <- map["MYSET7"]
        myset9 <- map["MYSET9"]
        mgruserid <- map["MGRUSERID"]
        credate <- map["CREDATE"]
        unitarea <- map["UNITAREA"]
        startdate <- map["STARTDATE"]
        blockname <- map["BLOCKNAME"]
        sortbar <- map["SORTBAR"]
        callorderstr <- map["CALLORDERSTR"]
        otherused <- map["OTHERUSED"]
        cellmm <- map["CELLMM"]
        usertype <- map["USERTYPE"] //身份类别 F家属 O业主 R租客
        logintoken <- map["LOGINTOKEN"]
        blockno <- map["BLOCKNO"]
        ismgr <- map["ISMGR"]//标识此用户在本房屋是否 为房管，房管可在手机端审核房屋申请
        rentername <- map["RENTERNAME"]
        renterid <- map["RENTERID"]
        doorside <- map["DOORSIDE"]
        communityid <- map["COMMUNITYID"]
        locks <- (map["LOCKS"], ListTransform<UnitLockModel>())
        moudle1 <- map["MOUDLE1"]
        moudle2 <- map["MOUDLE2"]
        userid <- map["USERID"]
        moudle3 <- map["MOUDLE3"]
        cellname <- map["CELLNAME"]
        moudle4 <- map["MOUDLE4"]
        moudle10 <- map["MOUDLE10"]
        myset2 <- map["MYSET2"]
        cellid <- map["CELLID"]
        moudle11 <- map["MOUDLE11"]
        physicalfloor <- map["PHYSICALFLOOR"]
        moudle16 <- map["MOUDLE16"]
        moudle17 <- map["MOUDLE17"]

        stringValue1 <- map["MOUDLE18"]
    }
}
