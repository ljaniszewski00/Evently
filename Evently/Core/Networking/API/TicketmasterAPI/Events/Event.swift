import Foundation

struct Event: Codable {
    let id: String
    let name: String
    let dates: Dates
    let place: Place?
    let embedded: Embedded
    let images: [EventImage]
    
    enum CodingKeys: String, CodingKey {
        case id, name, dates, place, images
        case embedded = "_embedded"
    }
}

extension Event: Equatable, Identifiable, Hashable {
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Event {
    var dateString: String? {
        if let dateFromApi = dates.startDate.dateTime,
           let date = DateFormatter.apiDateFormatter.date(from: dateFromApi) {
            return DateFormatter.displayDateFormatter.string(from: date)
        }
        
        let localDateFromApi = dates.startDate.localDate
        guard let date = DateFormatter.apiLocalDateFormatter.date(from: localDateFromApi) else {
            return nil
        }
        
        return DateFormatter.displayDateFormatter.string(from: date)
    }
    
    var timeString: String? {
        if let dateFromApi = dates.startDate.dateTime,
           let date = DateFormatter.apiDateFormatter.date(from: dateFromApi) {
            return DateFormatter.displayTimeFormatter.string(from: date)
        }
        
        guard let localTimeFromApi = dates.startDate.localTime,
              let time = DateFormatter.apiLocalTimeFormatter.date(from: localTimeFromApi) else {
            return nil
        }
        
        return DateFormatter.displayTimeFormatter.string(from: time)
    }
}

extension Event {
    static let sampleEvent: Event = Event(
        id: "G5diZfkn0B-bh",
        name: "Radiohead",
        dates: Dates(
            startDate: StartDate(
                localDate: "2016-07-27",
                localTime: "19:30:00",
                dateTime: "2016-07-27T23:30:00Z"
            )
        ),
        place: Place(
            name: "Madison Square Garden",
            address: Address(
                line1: "7th Ave & 32nd Street",
                line2: nil,
                line3: nil),
            city: City(name: "New York"),
            country: Country(name: "United States of America")
        ),
        embedded: Embedded(
            venues: [
                Place(
                    name: "Madison Square Garden",
                    address: Address(
                        line1: "7th Ave & 32nd Street",
                        line2: nil,
                        line3: nil),
                    city: City(name: "New York"),
                    country: Country(name: "United States of America")
                )
            ]
        ),
        images: [
            EventImage(url: "http://s1.ticketm.net/dam/a/c4c/e751ab33-b9cd-4d24-ad4a-5ef79faa7c4c_72681_EVENT_DETAIL_PAGE_16_9.jpg"),
            EventImage(url: "http://s1.ticketm.net/dam/a/c4c/e751ab33-b9cd-4d24-ad4a-5ef79faa7c4c_72681_RETINA_LANDSCAPE_16_9.jpg"),
        ]
    )
}
