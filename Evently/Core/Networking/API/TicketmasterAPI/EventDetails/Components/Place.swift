struct Place: Decodable {
    let name: String
    let address: Address
    let city: City
    let country: Country
}

struct Country: Decodable {
    let name: String
}

struct City: Decodable {
    let name: String
}

struct Address: Decodable {
    let line1: String?
    let line2: String?
    let line3: String?
}
