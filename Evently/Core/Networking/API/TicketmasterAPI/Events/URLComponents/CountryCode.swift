enum Country {
    case poland
}

extension Country {
    var name: String {
        switch self {
        case .poland:
            "Poland"
        }
    }
    
    var apiCode: String {
        switch self {
        case .poland:
            "PL"
        }
    }
}
