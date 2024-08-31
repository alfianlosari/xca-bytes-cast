import Foundation

final class Cache<V> {
    
    fileprivate let cache: NSCache<NSString, CacheEntry<V>> = .init()
    
    subscript(_ key: String) -> V? {
        get { value(forKey: key) }
        set { setValue(newValue, forKey: key)}
    }

    func setValue(_ value: V?, forKey key: String, expiredTimestamp: Date? = nil) {
        if let value = value {
            let cacheEntry = CacheEntry(key: key, value: value, expiredTimestamp: expiredTimestamp)
              print("Cache: Set \(key) with value of \(value)")
              cache.setObject(cacheEntry, forKey: key as NSString)
        } else {
            removeValue(forKey: key)
        }
    }
    
    func value(forKey key: String) -> V? {
        guard let entry = cache.object(forKey: key as NSString) else {
            print("Cache: cache doesn't exist for \(key)")
            return nil
        }
        
        guard !entry.isCacheExpired(after: Date()) else {
            removeValue(forKey: key)
            print("Cache: expired cache data for \(key)")
            return nil
        }
        
        print("Cache: retrieved \(entry.value) for \(key)")
        return entry.value
    }
    
    func removeValue(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAllValues() {
        print("Cache: Purged all values")
        cache.removeAllObjects()
    }
}

