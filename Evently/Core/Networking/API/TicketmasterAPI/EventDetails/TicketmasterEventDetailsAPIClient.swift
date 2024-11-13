import Foundation

class TicketmasterEventDetailsAPIClient: APIClientProtocol, TicketmasterEventDetailsAPIClientProtocol {
    var endpoint: APIEndpoint
    var apiKeyProvider: APIKeyProviding = TicketmasterAPIKeyProvider()
    
    var eventId: String
    
    init(eventId: String) {
        self.eventId = eventId
        self.endpoint = TicketmasterAPIEndpoint.eventDetails(eventId: eventId)
    }
    
    func fetchEventDetails() async throws -> EventDetails {
        guard var urlComponents = URLComponents(string: endpoint.path) else {
            throw APIError.invalidURL
        }
        
        guard let apiKey = apiKeyProvider.provideAPIKey() else {
            throw APIError.missingAPIKey
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(EventDetails.self, from: data)
            return result
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }
}

protocol TicketmasterEventDetailsAPIClientProtocol {
    var eventId: String { get }
    
    func fetchEventDetails() async throws -> EventDetails
}
