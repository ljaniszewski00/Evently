struct Dates: Codable {
    let startDate: StartDate
    
    enum CodingKeys: String, CodingKey {
        case startDate = "start"
    }
}

struct StartDate: Codable {
    let localDate: String
    let localTime: String?
    let dateTime: String?
}
