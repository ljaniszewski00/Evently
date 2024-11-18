@testable import Evently

actor MockTicketmasterEventDetailsAPIClientWithSuccess: TicketmasterEventDetailsAPIClientProtocol {
    nonisolated let eventId: String = EventDetails.sampleEventDetails.id
    
    func fetchEventDetails() async throws -> Evently.EventDetails {
        EventDetails.sampleEventDetails
    }
}

actor MockTicketmasterEventDetailsAPIClientWithDecodingFailure: TicketmasterEventDetailsAPIClientProtocol {
    nonisolated let eventId: String = EventDetails.sampleEventDetails.id
    
    func fetchEventDetails() async throws -> Evently.EventDetails {
        throw APIError.decodingError.rawValue
    }
}
