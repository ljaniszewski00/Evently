struct EventEmbedded: Codable {
    let venues: [EventPlace]
    
    enum CodingKeys: String, CodingKey {
        case venues
    }
}
