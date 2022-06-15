//
//  UnitCodesModel.swift
//  SmartCommunity
//
//  Created by Anjie on 2021/12/29.
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
