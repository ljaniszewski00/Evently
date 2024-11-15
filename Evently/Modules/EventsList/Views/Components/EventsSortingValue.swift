enum EventsSortingValue: String {
    case name = "Name"
    case date = "Date"
    case relevance = "Relevance"
    case distance = "Distance"
    case saleStartDate = "Sale Start Date"
    case venueName = "Venue Name"
}

extension EventsSortingValue: CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
}

extension EventsSortingValue {
    var apiCodingName: String {
        switch self {
        case .name:
            "name"
        case .date:
            "date"
        case .relevance:
            "relevance"
        case .distance:
            "distance"
        case .saleStartDate:
            "onSaleStartDate"
        case .venueName:
            "venueName"
        }
    }
    
    var availableSortingTypes: [EventsSortingType] {
        switch self {
        case .name:
            [.ascending, .descending]
        case .date:
            [.ascending, .descending]
        case .relevance:
            [.ascending, .descending]
        case .distance:
            [.ascending]
        case .saleStartDate:
            [.ascending]
        case .venueName:
            [.ascending, .descending]
        }
    }
}
