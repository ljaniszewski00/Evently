struct Event: Identifiable, Decodable {
    let id: String
    let name: String
    let dates: Dates
    let place: Place
    let images: [EventImage]
    
    enum CodingKeys: String, CodingKey {
        case id, name, dates, place, images
    }
}
