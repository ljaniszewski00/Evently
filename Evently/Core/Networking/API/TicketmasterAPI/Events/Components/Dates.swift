struct Dates: Decodable {
    let startDate: StartDate
    
    enum CodingKeys: String, CodingKey {
        case startDate = "start"
    }
}

struct StartDate: Decodable {
    let localDate: String
    let localTime: String?
}
