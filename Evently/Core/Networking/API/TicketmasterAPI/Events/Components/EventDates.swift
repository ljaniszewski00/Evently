struct EventDates: Codable {
    let startDate: EventStartDate
    
    enum CodingKeys: String, CodingKey {
        case startDate = "start"
    }
}

struct EventStartDate: Codable {
    let localDate: String
    let localTime: String?
    let dateTime: String?
}
