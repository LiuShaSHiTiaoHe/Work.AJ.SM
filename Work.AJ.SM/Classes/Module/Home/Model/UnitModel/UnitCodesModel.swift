//
//  UnitCodesModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/29.
//

import UIKit
import RealmSwift

class UnitCodesModel: Object, Mappable {
    @Persisted var communityid: Int?
    @Persisted var showfloor: String?
    @Persisted var increaseid: Int?
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "codes") var assignee: LinkingObjects<UnitModel>

    required convenience init?(map: ObjectMapper.Map) {
      self.init()
    }

    // Mappable
    func mapping(map: ObjectMapper.Map) {
        communityid <- map["COMMUNITYID"]
        showfloor <- map["SHOWFLOOR"]
        increaseid <- map["INCREASEID"]
    }
}
