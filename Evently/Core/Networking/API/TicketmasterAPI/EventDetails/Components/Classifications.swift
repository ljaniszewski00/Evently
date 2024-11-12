struct Classifications: Decodable {
    let segment: Segment
    let genre: Genre
    let subgenre: Subgenre?
}

struct Segment: Decodable {
    let name: String
}

struct Genre: Decodable {
    let name: String
}

struct Subgenre: Decodable {
    let name: String
}
