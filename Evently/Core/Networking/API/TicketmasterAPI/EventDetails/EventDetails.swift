struct EventDetails: Identifiable, Decodable {
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
