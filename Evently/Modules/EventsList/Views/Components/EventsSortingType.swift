enum EventsSortingType: String {
    case ascending = "Ascending"
    case descending = "Descending"
}

extension EventsSortingType: CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
}

extension EventsSortingType {
    var apiCodingName: String {
        switch self {
        case .ascending:
            "asc"
        case .descending:
            "desc"
        }
    }
}
