//
//  FaceModel.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/28.
//

import ObjectMapper

class FaceModel: Mappable {
    var mobile: String?
    var userID: Int?
    var unitID: Int?
    var cellID: Int?
    var communityID: Int?
    var blockID: Int?
    var isValid: String?
    var faceType: String?//“0”：本人；“1”：父母；“2”：子女；“3”：亲属
    var unitFaceID: Int?
    
    var faceID: Int?
    var credate: String?
    var image: String?
    var name: String?
    var type: String?
    var folderpath: String?//新增相对路径
    //完整的图片链接
    var imageurl: String? {
        get {
            if let image = image, !image.isEmpty, let folder = folderpath {
                return (folder + image).ajImageUrl()
            }
            return nil
        }
    }
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        mobile <- map["MOBILE"]
        userID <- map["USERID"]
        unitID <- map["UNITID"]
        communityID <- map["COMMUNITYID"]
        cellID <- map["CELLID"]
        blockID <- map["BLOCKID"]
        isValid <- map["ISVALID"]
        faceType <- map["FACETYPE"]
        unitFaceID <- map["UNITFACEID"]
        faceID <- map["ID"]
        credate <- map["CREATEDATE"]
        image <- map["IMAGE"]
        name <- map["NAME"]
        type <- map["TYPE"]
        folderpath <- map["FOLDERPATH"]
    }
    
}
