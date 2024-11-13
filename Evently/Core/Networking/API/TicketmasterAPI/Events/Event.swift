struct Event: Codable {
    let id: String
    let name: String
    let dates: Dates
    let place: Place?
    let images: [EventImage]
    
    enum CodingKeys: String, CodingKey {
        case id, name, dates, place, images
    }
}

extension Event: Equatable, Identifiable, Hashable {
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
