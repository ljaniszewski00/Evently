@testable import Evently

struct MockTicketmasterEventDetailsAPIClientWithSuccess: TicketmasterEventDetailsAPIClientProtocol {
    var eventId: String = EventDetails.sampleEventDetails.id
    
    func fetchEventDetails() async throws -> Evently.EventDetails {
        EventDetails.sampleEventDetails
    }
}

struct MockTicketmasterEventDetailsAPIClientWithDecodingFailure: TicketmasterEventDetailsAPIClientProtocol {
    var eventId: String = EventDetails.sampleEventDetails.id
    
    func fetchEventDetails() async throws -> Evently.EventDetails {
        throw APIError.decodingError.rawValue
    }
}
