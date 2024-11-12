enum APIError: Error {
    case invalidURL
    case missingAPIKey
    case invalidResponse
    case decodingError
    case networkError(Error)
}
