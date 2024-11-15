enum EventsSortingValue: String {
    case ascending = "Ascending"
    case descending = "Descending"
}

extension EventsSortingValue: CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
}

extension EventsSortingValue {
    var apiCodingName: String {
        switch self {
        case .ascending:
            "asc"
        case .descending:
            "desc"
        }
    }
}
