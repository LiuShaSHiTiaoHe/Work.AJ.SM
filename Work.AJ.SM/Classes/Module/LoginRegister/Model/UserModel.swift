//
//  UserModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/14.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class UserModel: Object, Mappable  {
    
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

