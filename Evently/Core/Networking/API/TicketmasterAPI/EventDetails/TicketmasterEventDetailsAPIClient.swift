import Foundation

actor TicketmasterEventDetailsAPIClient: APIClientProtocol, TicketmasterEventDetailsAPIClientProtocol {
    nonisolated let endpoint: APIEndpoint
    var apiKeyProvider: APIKeyProviding = TicketmasterAPIKeyProvider()
    
    nonisolated let eventId: String
    
    private let decoder: JSONDecoder = JSONDecoder()
    
    init(eventId: String) {
        self.eventId = eventId
        self.endpoint = TicketmasterAPIEndpoint.eventDetails(eventId: eventId)
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchEventDetails() async throws -> EventDetails {
        guard var urlComponents = URLComponents(string: endpoint.path) else {
            throw APIError.invalidURL.rawValue
        }
        
        guard let apiKey = apiKeyProvider.provideAPIKey() else {
            throw APIError.missingAPIKey.rawValue
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: TicketmasterURLComponents.apiKey.rawValue,
                         value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL.rawValue
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse.rawValue
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(EventDetails.self, from: data)
            return result
        } catch {
            throw APIError.decodingError.rawValue
        }
    }
}

protocol TicketmasterEventDetailsAPIClientProtocol {
    var eventId: String { get }
    
    func fetchEventDetails() async throws -> EventDetails
}
