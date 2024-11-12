import Foundation

enum TicketmasterAPIEndpoint {
    case events
    case eventDetails(eventId: String)
}

extension TicketmasterAPIEndpoint: APIEndpoint {
    var baseURL: String {
        "https://app.ticketmaster.com/discovery/v2"
    }
    
    var path: String {
        switch self {
        case .events:
            return "\(baseURL)/events"
        case let .eventDetails(eventId):
            return "\(baseURL)/events/\(eventId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .events:
            return .get
        case .eventDetails:
            return .get
        }
    }
}
