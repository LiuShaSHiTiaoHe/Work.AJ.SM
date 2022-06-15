//
//  ExtralFaceModel.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/5/13.
//
import ObjectMapper

class ExtralFaceModel: Mappable {
    var faceID: Int?
    var communityID: Int?
    var blockID: Int?
    var cellID: Int?
    var unitID: Int?
    var faceFile: String?
    var image: String?
    var mobile: String?
    var folderPath: String?
    var isValid: String?
    var unitFaceID: Int?
    var createDate: String?

    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        faceID <- map["ID"]
        communityID <- map["COMMUNITYID"]
        blockID <- map["BLOCKID"]
        cellID <- map["CELLID"]
        unitID <- map["UNITID"]
        faceFile <- map["FACEFILE"]
        image <- map["IMAGE"]
        mobile <- map["MOBILE"]
        folderPath <- map["FOLDERPATH"]
        isValid <- map["ISVALID"]
        unitFaceID <- map["UNITFACEID"]
        createDate <- map["CREATEDATE"]
    }
    
}
