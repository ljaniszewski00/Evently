enum EventsSortingKey: String {
    case name = "Name"
    case date = "Date"
    case relevance = "Relevance"
    case distance = "Distance"
    case saleStartDate = "Sale Start Date"
    case venueName = "Venue Name"
}

extension EventsSortingKey: CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
}

extension EventsSortingKey {
    var name: String {
        switch self {
        case .name:
            "Name"
        case .date:
            "Date"
        case .relevance:
            "Relevance"
        case .distance:
            "Distance"
        case .saleStartDate:
            "Sale Start Date"
        case .venueName:
            "Venue Name"
        }
    }
    
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
    
    var availableSortingValues: [EventsSortingValue] {
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
