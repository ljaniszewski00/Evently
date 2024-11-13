struct Place: Codable {
    let name: String
    let address: Address
    let city: City
    let country: Country
}

struct Country: Codable {
    let name: String
}

struct City: Codable {
    let name: String
}

struct Address: Codable {
    let line1: String?
    let line2: String?
    let line3: String?
}
