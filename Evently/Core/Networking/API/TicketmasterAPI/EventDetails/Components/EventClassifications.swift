struct EventClassifications: Codable {
    let segment: EventSegment
    let genre: EventGenre
    let subgenre: EventSubgenre?
}

struct EventSegment: Codable {
    let name: String
}

struct EventGenre: Codable {
    let name: String
}

struct EventSubgenre: Codable {
    let name: String
}
