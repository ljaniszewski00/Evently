import Foundation

actor EventDetailsCacheManager: EventDetailsCacheManaging {
    private let cache = NSCache<KeyType, Value>()
    
    private init() {}
    
    static let shared: EventDetailsCacheManager = EventDetailsCacheManager()
    
    func getObjectFromCache(for key: String) async -> Result<Value, String> {
        guard let fetchedObject = cache.object(forKey: key as KeyType) else {
            return .failure(CacheError.getObjectError.rawValue)
        }
        
        return .success(fetchedObject)
    }
    
    func addObjectToCache(_ object: Value, for key: String) async {
        cache.setObject(object, forKey: key as KeyType)
    }
    
    func removeObjectFromCache(for key: String) async {
        cache.removeObject(forKey: key as KeyType)
    }
}

protocol EventDetailsCacheManaging {
    typealias KeyType = NSString
    typealias Value = EventDetailsObject
    
    func getObjectFromCache(for key: String) async -> Result<Value, String>
    func addObjectToCache(_ object: Value, for key: String) async
    func removeObjectFromCache(for key: String) async
}
