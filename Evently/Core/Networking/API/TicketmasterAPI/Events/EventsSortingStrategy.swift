enum EventsSortingStrategy {
    case nameAscending
    case nameDescending
    case dateAscending
    case dateDescending
    case relevanceAscending
    case relevanceDescending
    case distanceAscending
    case saleStartDateAscending
    case venueNameAscending
    case venueNameDescending
}

extension EventsSortingStrategy {
    var apiCodingName: String {
        switch self {
        case .nameAscending:
            "\(EventsSortingValue.name.apiCodingName),\(EventsSortingType.ascending.apiCodingName)"
        case .nameDescending:
            "\(EventsSortingValue.name.apiCodingName),\(EventsSortingType.descending.apiCodingName)"
        case .dateAscending:
            "\(EventsSortingValue.date.apiCodingName),\(EventsSortingType.ascending.apiCodingName)"
        case .dateDescending:
            "\(EventsSortingValue.date.apiCodingName),\(EventsSortingType.descending.apiCodingName)"
        case .relevanceAscending:
            "\(EventsSortingValue.relevance.apiCodingName),\(EventsSortingType.ascending.apiCodingName)"
        case .relevanceDescending:
            "\(EventsSortingValue.relevance.apiCodingName),\(EventsSortingType.descending.apiCodingName)"
        case .distanceAscending:
            "\(EventsSortingValue.distance.apiCodingName),\(EventsSortingType.ascending.apiCodingName)"
        case .saleStartDateAscending:
            "\(EventsSortingValue.saleStartDate.apiCodingName),\(EventsSortingType.ascending.apiCodingName)"
        case .venueNameAscending:
            "\(EventsSortingValue.venueName.apiCodingName),\(EventsSortingType.ascending.apiCodingName)"
        case .venueNameDescending:
            "\(EventsSortingValue.venueName.apiCodingName),\(EventsSortingType.descending.apiCodingName)"
        }
    }
}
