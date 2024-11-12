struct EventResponse: Decodable {
    let embedded: ResponseEmbedded
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct ResponseEmbedded: Decodable {
    let events: [Event]
}
