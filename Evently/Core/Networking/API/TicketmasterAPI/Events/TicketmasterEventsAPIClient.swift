import Foundation

class TicketmasterEventsAPIClient: APIClientProtocol, TicketmasterEventsAPIClientProtocol {
    var endpoint: APIEndpoint = TicketmasterAPIEndpoint.events
    var apiKeyProvider: APIKeyProviding = TicketmasterAPIKeyProvider()
    
    func fetchEvents(
        country: String,
        page: String,
        size: String,
        with sortingStrategy: String
    ) async throws -> [Event] {
        guard var urlComponents = URLComponents(string: endpoint.path) else {
            throw APIError.invalidURL
        }
        
        guard let apiKey = apiKeyProvider.provideAPIKey() else {
            throw APIError.missingAPIKey
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: TicketmasterURLComponents.apiKey.rawValue,
                         value: apiKey),
            URLQueryItem(name: TicketmasterURLComponents.countryCode.rawValue,
                         value: country),
            URLQueryItem(name: TicketmasterURLComponents.page.rawValue,
                         value: page),
            URLQueryItem(name: TicketmasterURLComponents.size.rawValue,
                         value: size),
            URLQueryItem(name: TicketmasterURLComponents.sort.rawValue,
                         value: sortingStrategy)
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
            return result.embedded.events
        } catch {
            throw APIError.decodingError
        }
    }
}

protocol TicketmasterEventsAPIClientProtocol {
    func fetchEvents(
        country: String,
        page: String,
        size: String,
        with sortingStrategy: String
    ) async throws -> [Event]
}
