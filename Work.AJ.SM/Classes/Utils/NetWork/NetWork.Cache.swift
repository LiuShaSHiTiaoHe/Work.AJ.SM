//
//  NetWork.Cache.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/6.
//

import Foundation
import Moya
import SwiftyJSON

// MARK: - Cache Type
public enum NetworkCacheType {
    /** 只从网络获取数据，且数据不会缓存在本地 */
    /** Only get data from the network, and the data will not be cached locally */
    case ignoreCache
    /** 先从缓存读取数据，如果没有再从网络获取 */
    /** Read the data from the cache first, if not, then get it from the network */
    case cacheElseNetwork
    /** 先从网络获取数据，如果没有在从缓存获取，此处的没有可以理解为访问网络失败，再从缓存读取 */
    /** Get data from the network first, if not from the cache */
    case networkElseCache
    /** 先从缓存读取数据，然后在从网络获取并且缓存，缓存数据通过闭包丢出去 */
    /** First read the data from the cache, then get it from the network and cache it, the cached data is thrown out through the closure */
    case cacheThenNetwork
}

// MARK: - NetWork Cahce
extension TargetType {

    var cachedKey: String {
        if let urlRequest = try? endpoint.urlRequest(),
           let data = urlRequest.httpBody,
           let parameters = String(data: data, encoding: .utf8) {
            return "\(method.rawValue):\(endpoint.url)"
        }
        return "\(method.rawValue):\(endpoint.url)"
    }

    var endpoint: Endpoint {
        return Endpoint(url: URL(target: self).absoluteString,
                sampleResponseClosure: { .networkResponse(200, self.sampleData) },
                method: method,
                task: task,
                httpHeaderFields: headers)
    }

    func readCacheResponse() -> Moya.Response? {
        guard let dict = CacheManager.network.fetchCachedWithKey(cachedKey),
              let statusCode = dict.value(forKey: "statusCode") as? Int,
              let data = dict.value(forKey: "data") as? Data
        else {
            return nil
        }
        let response = Response(statusCode: statusCode, data: data)

        return response
    }

    func saveCacheResponse(_ response: Moya.Response?) {
        guard let response = response else {
            return
        }
        let key = cachedKey
        let storage: NSDictionary = [
            "data": response.data,
            "statusCode": response.statusCode
        ]
        DispatchQueue.global().async {
            CacheManager.network.saveCacheWithDictionary(storage, key: key)
        }
    }


}



