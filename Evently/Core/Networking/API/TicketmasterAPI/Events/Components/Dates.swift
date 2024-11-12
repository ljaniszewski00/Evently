struct Dates: Decodable {
    let startDate: StartDate
}

struct StartDate: Decodable {
    let localDate: String
    let localTime: String?
}
