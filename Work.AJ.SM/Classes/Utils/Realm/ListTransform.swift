//
//  ListTransform.swift
//  Work.AJ.SM
//
//  Created by guguijun on 2022/9/20.
//

import Foundation
import ObjectMapper
import RealmSwift

public struct ListTransform<T: RealmSwift.Object>: TransformType where T: BaseMappable {
    
    public typealias Serialize = (List<T>) -> ()
    private let onSerialize: Serialize
    
    public init(onSerialize: @escaping Serialize = { _ in }) {
        self.onSerialize = onSerialize
    }
    
    public typealias Object = List<T>
    public typealias JSON = Array<Any>
    
    public func transformFromJSON(_ value: Any?) -> List<T>? {
        let list = List<T>()
        if let objects = Mapper<T>().mapArray(JSONObject: value) {
            list.append(objectsIn: objects)
        }
        self.onSerialize(list)
        return list
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value?.compactMap { $0.toJSON() }
    }
    
}
