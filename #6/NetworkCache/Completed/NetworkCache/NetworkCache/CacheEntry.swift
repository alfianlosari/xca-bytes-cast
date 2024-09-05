import Foundation

final class CacheEntry<V> {
    
    let key: String
    let value: V
    let expiredTimestamp: Date?
    
    init(key: String, value: V, expiredTimestamp: Date? = nil) {
        self.key = key
        self.value = value
        self.expiredTimestamp =  expiredTimestamp
    }
    
    func isCacheExpired(after date: Date = .now) -> Bool {
        guard let expiredTimestamp else {
            return false
        }
        return date > expiredTimestamp
    }
    
}
