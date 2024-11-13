struct Classifications: Codable {
    let segment: Segment
    let genre: Genre
    let subgenre: Subgenre?
}

struct Segment: Codable {
    let name: String
}

struct Genre: Codable {
    let name: String
}

struct Subgenre: Codable {
    let name: String
}
