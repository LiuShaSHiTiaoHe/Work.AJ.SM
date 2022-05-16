//
//  Cache.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/22.
//

import UIKit
import YYCache

let FaceImageCacheKey = "FaceImageCacheKey"
let UserAvatarCacheKey = "UserAvatarCacheKey"


enum CacheManager: String {
    case network = "anjie.network.cache"
    case liftrecord = "anjie.liftrecord.cache"
    case normal = "anjie.normal.cache"

    /// Current cached size
    var totalCost: Int {
        if let cache = YYCache.init(name: self.rawValue) {
            return cache.diskCache.totalCost()
        }
        return 0
    }

    /// The current number of cached items
    var totalCount: Int {
        if let cache = YYCache.init(name: self.rawValue) {
            return cache.diskCache.totalCount()
        }
        return 0
    }

    /// Delete the disk cache
    func removeAllCache() {
        if let cache = YYCache.init(name: self.rawValue) {
            cache.diskCache.removeAllObjects()
        }
    }

    func removeCacheWithKey(_ key: String) {
        if let cache = YYCache.init(name: self.rawValue) {
            cache.diskCache.removeObject(forKey: key)
        }
    }

    /// Cache data
    /// - Parameters:
    ///   - dict: The cached object
    ///   - key: Cache key name
    func saveCacheWithDictionary(_ dict: NSDictionary, key: String) {
        if let cache = YYCache.init(name: self.rawValue) {
            cache.diskCache.countLimit = maxCountLimit
            cache.diskCache.costLimit = maxCostLimit
            cache.diskCache.ageLimit = maxAgeLimit
            cache.diskCache.freeDiskSpaceLimit = freeDiskSpaceLimit
            cache.setObject(dict, forKey: key)
        }
    }

    /// Read cache data
    /// - Parameter key: Cache key name
    /// - Returns: Cache object
    func fetchCachedWithKey(_ key: String) -> NSDictionary? {
        if let cache = YYCache.init(name: self.rawValue) {
            return cache.object(forKey: key) as? NSDictionary
        }
        return nil
    }

    // MARK: - Private
    /// The maximum number of objects the cache should hold. default 100
    private var maxCountLimit: UInt {
        switch self {
        case .network:
            return 200
        case .liftrecord:
            return 200
        case .normal:
            return 1000
        }
    }

    /// The maximum total cost that the cache can hold before it starts evicting objects. default 20kb
    private var maxCostLimit: UInt {
        return 30 * 1024
    }

    /// The maximum expiry time of objects in cache.
    private var maxAgeLimit: TimeInterval {
        return TimeInterval(MAXFLOAT)
    }

    /// The minimum free disk space (in bytes) which the cache should kept.
    private var freeDiskSpaceLimit: UInt {
        return 0
    }
}
