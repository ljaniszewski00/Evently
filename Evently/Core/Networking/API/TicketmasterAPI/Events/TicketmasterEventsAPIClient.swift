import Foundation

class TicketmasterEventsAPIClient: APIClientProtocol, TicketmasterEventsAPIClientProtocol {
    var endpoint: APIEndpoint = TicketmasterAPIEndpoint.events
    var apiKeyProvider: APIKeyProviding = TicketmasterAPIKeyProvider()
    
    func fetchEvents(page: Int) async throws -> [Event] {
        guard var urlComponents = URLComponents(string: endpoint.path) else {
            throw APIError.invalidURL
        }
        
        guard let apiKey = apiKeyProvider.provideAPIKey() else {
            throw APIError.missingAPIKey
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "countryCode", value: "PL"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: "20")
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
            let result = try decoder.decode(EventResponse.self, from: data)
            return result.events
        } catch {
            throw APIError.decodingError
        }
    }
}

protocol TicketmasterEventsAPIClientProtocol {
    func fetchEvents(page: Int) async throws -> [Event]
}
