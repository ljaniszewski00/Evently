enum EventsSortingStrategy: String, CaseIterable {
    case nameAscending = "name,asc"
    case nameDescending = "name,desc"
    case dateAscending = "date,asc"
    case dateDescending = "date,desc"
    case relevanceAscending = "relevance,asc"
    case relevanceDescending = "relevance,desc"
    case distanceAscending = "distance,asc"
    case saleStartDateAscending = "onSaleStartDate,asc"
    case venueNameAscending = "venueName,asc"
    case venueNameDescending = "venueName,desc"
}

extension EventsSortingStrategy {
    var name: String {
        switch self {
        case .nameAscending:
            return "Name Ascending"
        case .nameDescending:
            return "Name Descending"
        case .dateAscending:
            return "Date Ascending"
        case .dateDescending:
            return "Date Descending"
        case .relevanceAscending:
            return "Relevance Ascending"
        case .relevanceDescending:
            return "Relevance Descending"
        case .distanceAscending:
            return "Distance Ascending"
        case .saleStartDateAscending:
            return "Sale Start Date Ascending"
        case .venueNameAscending:
            return "Venue Name Ascending"
        case .venueNameDescending:
            return "Venue Name Descending"
        }
    }
}
