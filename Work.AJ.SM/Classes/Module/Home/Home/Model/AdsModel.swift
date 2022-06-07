//
//  AdsModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/30.
//

import UIKit

class AdsModel: Mappable {

    var adid: String?
    var covers: String? //位置  a首页  b商圈 c开门
    var credate: String?
    var picurl: String?
    var rid: String?
    var state: String?
    var title: String?
    var adurl: String? //图片链接

    //是否有广告链接
    var hasadurl: Bool {
        get {
            if let adurl = adurl, !adurl.isEmpty {
                return true
            }
            return false
        }
    }
    //完整的图片链接
    var imageurl: String {
        get {
            if let picurl = picurl, !picurl.isEmpty {
                return ApiBaseUrl() + picurl
            }
            return ""
        }
    }
    var folderpath: String?//新增相对路径

    required init?(map: ObjectMapper.Map) {
    }

    func mapping(map: ObjectMapper.Map) {
        adid <- map["ADID"]
        covers <- map["COVERS"]
        credate <- map["CREDATE"]
        picurl <- map["PICURL"]
        rid <- map["RID"]
        state <- map["STATE"]
        title <- map["TITLE"]
        adurl <- map["ADURL"]
    }


}
