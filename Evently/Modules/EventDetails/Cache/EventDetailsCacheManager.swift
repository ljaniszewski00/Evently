import Foundation

final class EventDetailsCacheManager {
    typealias KeyType = NSString
    typealias Value = EventDetailsObject
    
    private let cache = NSCache<KeyType, Value>()
    
    private init() {}
    
    static let shared: EventDetailsCacheManager = EventDetailsCacheManager()
    
    func getObjectFromCache(for key: String) -> Result<Value, String> {
        guard let fetchedObject = cache.object(forKey: key as KeyType) else {
            return .failure(CacheError.getObjectError.rawValue)
        }
        
        return .success(fetchedObject)
    }
    
    func addObjectToCache(_ object: Value, for key: String) {
        cache.setObject(object, forKey: key as KeyType)
    }
    
    func removeObjectFromCache(for key: String) {
        cache.removeObject(forKey: key as KeyType)
    }
}
