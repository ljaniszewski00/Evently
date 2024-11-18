@testable import Evently

actor MockTicketmasterEventsAPIClientWithTwoEvents: TicketmasterEventsAPIClientProtocol {
    func fetchEvents(
        country: String,
        page: String,
        size: String,
        with sortingStrategy: String
    ) async throws -> [Evently.Event] {
        [
            .sampleEvent,
            .sampleEvent
        ]
    }
}

actor MockTicketmasterEventsAPIClientWithDecodingFailure: TicketmasterEventsAPIClientProtocol {
    func fetchEvents(
        country: String,
        page: String,
        size: String,
        with sortingStrategy: String
    ) async throws -> [Evently.Event] {
        throw APIError.decodingError.rawValue
    }
}
