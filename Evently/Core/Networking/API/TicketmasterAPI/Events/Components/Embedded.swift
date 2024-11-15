struct Embedded: Codable {
    let venues: [Place]
    
    enum CodingKeys: String, CodingKey {
        case venues
    }
}
