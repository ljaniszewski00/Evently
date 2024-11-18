import Foundation

struct EventDetails: Codable {
    let id: String
    let name: String
    let dates: EventDates
    let place: EventPlace?
    let classifications: [EventClassifications]
    let priceRanges: [EventPriceRange]?
    let embedded: EventEmbedded
    let images: [EventImage]
    let seatMap: EventSeatMap?
    
    enum CodingKeys: String, CodingKey {
        case id, name, dates, place, classifications, priceRanges, images
        case embedded = "_embedded"
        case seatMap = "seatmap"
    }
}

extension EventDetails: Equatable, Identifiable, Hashable {
    static func ==(lhs: EventDetails, rhs: EventDetails) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension EventDetails {
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
    
    func toObject() -> EventDetailsObject {
        EventDetailsObject(eventDetails: self)
    }
}

extension EventDetails {
    static let sampleEventDetails: EventDetails = EventDetails(
        id: "G5diZfkn0B-bh",
        name: "Radiohead",
        dates: EventDates(
            startDate: EventStartDate(
                localDate: "2016-07-27",
                localTime: "19:30:00",
                dateTime: "2016-07-27T23:30:00Z"
            )
        ),
        place: EventPlace(
            name: "Madison Square Garden",
            address: EventAddress(
                line1: "7th Ave & 32nd Street",
                line2: nil,
                line3: nil),
            city: EventCity(name: "New York"),
            country: EventCountry(name: "United States of America")
        ),
        classifications: [
            EventClassifications(
                segment: EventSegment(name: "Music"),
                genre: EventGenre(name: "Rock"),
                subgenre: EventSubgenre(name: "Alternative Rock"))
        ],
        priceRanges: [
            EventPriceRange(
                min: 80,
                max: 80,
                currency: "USD")
        ],
        embedded: EventEmbedded(
            venues: [
                EventPlace(
                    name: "Madison Square Garden",
                    address: EventAddress(
                        line1: "7th Ave & 32nd Street",
                        line2: nil,
                        line3: nil),
                    city: EventCity(name: "New York"),
                    country: EventCountry(name: "United States of America")
                )
            ]
        ),
        images: [
            EventImage(url: "http://s1.ticketm.net/dam/a/c4c/e751ab33-b9cd-4d24-ad4a-5ef79faa7c4c_72681_EVENT_DETAIL_PAGE_16_9.jpg"),
            EventImage(url: "http://s1.ticketm.net/dam/a/c4c/e751ab33-b9cd-4d24-ad4a-5ef79faa7c4c_72681_RETINA_LANDSCAPE_16_9.jpg"),
        ],
        seatMap: EventSeatMap(
            staticUrl: "https://maps.ticketmaster.com/maps/geometry/3/event/19005D0B8F9014F6/staticImage?type=png&systemId=HOST"
        )
    )
    
    static let secondSampleEventDetails: EventDetails = EventDetails(
        id: "Second Sample Event Details",
        name: "Radiohead Maybe?",
        dates: EventDates(
            startDate: EventStartDate(
                localDate: "2016-07-27",
                localTime: "19:30:00",
                dateTime: "2016-07-27T23:30:00Z"
            )
        ),
        place: EventPlace(
            name: "Madison Square Garden",
            address: EventAddress(
                line1: "7th Ave & 32nd Street",
                line2: nil,
                line3: nil),
            city: EventCity(name: "New York"),
            country: EventCountry(name: "United States of America")
        ),
        classifications: [
            EventClassifications(
                segment: EventSegment(name: "Music"),
                genre: EventGenre(name: "Rock"),
                subgenre: EventSubgenre(name: "Alternative Rock"))
        ],
        priceRanges: [
            EventPriceRange(
                min: 80,
                max: 80,
                currency: "USD")
        ],
        embedded: EventEmbedded(
            venues: [
                EventPlace(
                    name: "Madison Square Garden",
                    address: EventAddress(
                        line1: "7th Ave & 32nd Street",
                        line2: nil,
                        line3: nil),
                    city: EventCity(name: "New York"),
                    country: EventCountry(name: "United States of America")
                )
            ]
        ),
        images: [
            EventImage(url: "http://s1.ticketm.net/dam/a/c4c/e751ab33-b9cd-4d24-ad4a-5ef79faa7c4c_72681_EVENT_DETAIL_PAGE_16_9.jpg"),
            EventImage(url: "http://s1.ticketm.net/dam/a/c4c/e751ab33-b9cd-4d24-ad4a-5ef79faa7c4c_72681_RETINA_LANDSCAPE_16_9.jpg"),
        ],
        seatMap: EventSeatMap(
            staticUrl: "https://maps.ticketmaster.com/maps/geometry/3/event/19005D0B8F9014F6/staticImage?type=png&systemId=HOST"
        )
    )
}
