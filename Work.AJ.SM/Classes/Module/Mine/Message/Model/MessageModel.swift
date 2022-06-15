//
//  MessageModel.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/5/10.
//

import ObjectMapper

class MessageModel: Mappable {
    
    var ifRead: String?
    var ifReadName: String?

    var userID: Int?
    var resType: String?
    var resID: Int?
    var messageID: Int?
    var createTime: String?
    var title: String?
    var text: String?
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        ifRead <- map["IFREAD"]
        ifReadName <- map["IFREADNAME"]
        userID <- map["USERID"]
        resType <- map["RESTYPE"]
        resID <- map["RESID"]
        messageID <- map["MESSAGEID"]
        createTime <- map["CREATETIME"]
        title <- map["TITLE"]
        text <- map["TEXT"]

    }
    
}
