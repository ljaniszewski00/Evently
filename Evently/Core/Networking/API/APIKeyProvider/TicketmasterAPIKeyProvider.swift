import Foundation

struct TicketmasterAPIKeyProvider: APIKeyProviding {
    func provideAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: "TicketmasterAPIPropertyList",
                                          ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let plistDict = try? PropertyListSerialization.propertyList(from: data,
                                                                          options: .mutableContainers,
                                                                          format: nil) as? [String:String],
              let apiKey = plistDict.values.first else {
            return nil
        }
        
        return apiKey
    }
}
