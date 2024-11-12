struct EventResponse: Decodable {
    let events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case events = "_embedded"
    }
}
