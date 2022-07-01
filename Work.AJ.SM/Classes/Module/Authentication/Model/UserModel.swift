//
//  UserModel.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/14.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class UserModel: Object, Mappable {

    @Persisted var openID: String?
    @Persisted var ptnval: String?
    @Persisted var loginToken: String?
    @Persisted var callNo: String?
    @Persisted var folderPath: String?
    @Persisted var realName: String?
    @Persisted var servicePhone: String?
    @Persisted var signature: String?
    @Persisted var job: String?
    @Persisted var videoCall: String?
    @Persisted var HeadImageUrl: String?
    @Persisted var cstAddUp: String?
    @Persisted var education: String?
    @Persisted var birthdate: String?
    @Persisted var rid: String?
    @Persisted var ptnAddUp: String?
    @Persisted var sex: String?
    @Persisted var userName: String?
    @Persisted var mobile: String?


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

    // Mappable
    func mapping(map: ObjectMapper.Map) {
        openID <- map["OPENID"]
        ptnval <- map["PTNVAL"]
        loginToken <- map["LOGINTOKEN"]
        callNo <- map["CALLNO"]
        folderPath <- map["FOLDERPATH"]
        realName <- map["REALNAME"]
        servicePhone <- map["SERVICEPHONE"]
        signature <- map["SIGNATURE"]
        job <- map["JOB"]
        videoCall <- map["VIDEOCALL"]
        HeadImageUrl <- map["HEADIMGURL"]
        cstAddUp <- map["CSTADDUP"]
        education <- map["EDUCATION"]
        birthdate <- map["BIRTHDATE"]
        rid <- map["RID"]
        ptnAddUp <- map["PTNADDUP"]
        sex <- map["SEX"]
        userName <- map["USERNAME"]
        mobile <- map["MOBILE"]
    }

    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }

    override class func primaryKey() -> String? {
        return "mobile"
    }


}

