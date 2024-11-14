import Foundation

final class EventDetailsObject: NSObject, NSCoding {
    let eventDetails: EventDetails
    
    init(eventDetails: EventDetails) {
        self.eventDetails = eventDetails
        super.init()
    }
    
    //MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        let eventData = try? JSONEncoder().encode(eventDetails)
        coder.encode(eventData, forKey: "eventDetails")
    }
    
    init?(coder: NSCoder) {
        guard let eventData = coder.decodeObject(forKey: "eventDetails") as? Data,
              let decodedEvent = try? JSONDecoder().decode(
                EventDetails.self,
                from: eventData
              ) else {
            return nil
        }
        
        self.eventDetails = decodedEvent
        super.init()
    }
}
