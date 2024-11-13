struct EventDetails: Codable {
    let id: String
    let name: String
    let dates: Dates
    let place: Place?
    let classifications: [Classifications]
    let priceRanges: [PriceRange]?
    let images: [EventImage]
    let seatMap: SeatMap?
    
    enum CodingKeys: String, CodingKey {
        case id, name, dates, place, classifications, priceRanges, images, seatMap
    }
}

extension EventDetails: Equatable, Identifiable, Hashable {
    static func ==(lhs: EventDetails, rhs: EventDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
