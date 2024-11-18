@testable import Evently

actor MockEmptyEventDetailsCacheManager: EventDetailsCacheManaging {
    func getObjectFromCache(for key: String) async -> Result<Value, String> {
        .failure(CacheError.getObjectError.rawValue)
    }
    
    func addObjectToCache(_ object: Value, for key: String) async {
        return
    }
    
    func removeObjectFromCache(for key: String) async {
        return
    }
}

actor MockFilledEventDetailsCacheManager: EventDetailsCacheManaging {
    func getObjectFromCache(for key: String) async -> Result<Value, String> {
        let eventDetailsObject = EventDetailsObject(eventDetails: .secondSampleEventDetails)
        return .success(eventDetailsObject)
    }
    
    func addObjectToCache(_ object: Value, for key: String) async {
        return
    }
    
    func removeObjectFromCache(for key: String) async {
        return
    }
}
