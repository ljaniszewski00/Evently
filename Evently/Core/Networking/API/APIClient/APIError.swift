enum APIError: String {
    case invalidURL = "Error sending request. Please try refreshing data or try again later"
    case missingAPIKey = "Missing API Key. Please contact technical support"
    case invalidResponse = "Invalid response. Please try refreshing data or try again later"
    case decodingError = "Decoding Error. Please try refreshing data or try again later"
}
