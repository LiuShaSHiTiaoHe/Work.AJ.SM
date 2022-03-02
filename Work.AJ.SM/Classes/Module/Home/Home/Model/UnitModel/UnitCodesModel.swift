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

    ///reserved value
    @Persisted var reservedString1: String?
    @Persisted var reservedString2: String?
    @Persisted var reservedString3: String?
    @Persisted var reservedString4: String?
    @Persisted var reservedBool1: Bool = false
    @Persisted var reservedBool2: Bool = false
    @Persisted var reservedInt1: Int
    @Persisted var reservedInt2: Int
    
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
