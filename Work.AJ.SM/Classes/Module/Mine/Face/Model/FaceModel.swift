//
//  FaceModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/28.
//

import ObjectMapper

class FaceModel: Mappable {
    var faceID: String?
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
        faceID <- map["ID"]
        credate <- map["CREATEDATE"]
        image <- map["IMAGE"]
        name <- map["NAME"]
        type <- map["TYPE"]
        folderpath <- map["FOLDERPATH"]
    }
    
}
