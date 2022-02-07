//
//  UnitModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/29.
//

import Foundation
import ObjectMapper

class UnitModel: NSObject, Mappable  {
    
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
    
    var moudle1: String?
    var moudle2: String?
    var moudle3: String?
    var moudle4: String?
    var moudle5: String?
    var moudle6: String?
    var moudle7: String?
    var moudle8: String?
    var moudle9: String?
    var moudle10: String?
    var moudle11: String?
    var moudle12: String?
    var moudle13: String?
    var moudle14: String?
    var moudle15: String?

    var myset1: String?
    var myset2: String?
    var myset3: String?
    var myset4: String?
    var myset5: String?
    var myset6: String?
    var myset7: String?
    var myset8: String?
    var myset9: String?
    var myset10: String?
    var myset11: String?
    var myset12: String?
    
    var state: String?
    var enddate: String?
    var communityname: String?
    var auditdate: Int?
    var codes: [UnitCodesModel]?
    var unitid: Int?
    var defaultflag: String?
    var cellno: String?
    var bcards: [UnitBcardModel]?
    var operid: Int?
    var mobile: String?
    var rid, blockid: Int?
    var mac: String?
    var unitno: String?
    var buttons: [UnitButtonsModel]?
    var mgruserid: Int?
    var credate, unitarea: Int?
    var startdate: String?
    var blockname, sortbar, callorderstr: String?
    var otherused: Int?
    var cellmm, usertype, logintoken, blockno: String?
    var ismgr: Bool?
    var rentername, renterid: String?
    var doorside: String?
    var communityid: Int?
    var locks: [UnitLockModel]?
    var userid: Int?
    var cellname: String?
    var cellid: Int?
    var physicalfloor: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
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
        codes <- map["CODES"]
        unitid <- map["UNITID"]
        defaultflag <- map["DEFAULTFLAG"]
        myset10 <- map["MYSET10"]
        myset11 <- map["MYSET11"]
        myset12 <- map["MYSET12"]
        cellno <- map["CELLNO"]
        bcards <- map["BCARDS"]
        operid <- map["OPERID"]
        mobile <- map["MOBILE"]
        rid <- map["RID"]
        blockid <- map["BLOCKID"]
        mac <- map["MAC"]
        unitno <- map["UNITNO"]
        myset1 <- map["MYSET1"]
        myset3 <- map["MYSET3"]
        buttons <- map["BUTTONS"]
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
        locks <- map["LOCKS"]
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
    }
}
