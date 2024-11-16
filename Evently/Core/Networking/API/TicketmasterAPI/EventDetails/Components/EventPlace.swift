struct EventPlace: Codable {
    let name: String
    let address: EventAddress
    let city: EventCity
    let country: EventCountry
}

struct EventCountry: Codable {
    let name: String
}

struct EventCity: Codable {
    let name: String
}

struct EventAddress: Codable {
    let line1: String?
    let line2: String?
    let line3: String?
}
