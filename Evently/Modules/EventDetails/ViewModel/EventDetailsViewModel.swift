import Foundation
import SwiftUI

@MainActor
final class EventDetailsViewModel: ObservableObject {
    @Published var event: EventDetails?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private let apiClient: TicketmasterEventDetailsAPIClientProtocol
    private let cacheManager: EventDetailsCacheManaging
    
    var eventImagesURLs: [String] {
        guard let event = event else {
            return [""]
        }
        
        return event.images.map {
            $0.url
        }
    }
    
    var eventClassificationFormatted: String? {
        guard let eventClassification = event?.classifications.first else {
            return nil
        }
        
        return "\(eventClassification.segment.name) • \(eventClassification.genre.name)"
    }
    
    var eventDateTimeFormatted: String? {
        var eventDateTimeFormatted: String = ""
        
        if let eventDate = event?.dateString {
            eventDateTimeFormatted.append("\(eventDate), ")
        }
        
        if let eventTime = event?.timeString {
            eventDateTimeFormatted.append(eventTime)
        }
        
        guard !eventDateTimeFormatted.isEmpty else {
            return nil
        }
        
        return eventDateTimeFormatted
    }
    
    var eventPriceFormatted: String? {
        guard let prices = event?.priceRanges?.first else {
            return nil
        }
        
        return "\(String(format: "%.2f", prices.min)) \(prices.currency)"
    }
    
    var eventSeatMapURL: URL? {
        guard let eventSeatMapURLString = event?.seatMap?.staticUrl,
              !eventSeatMapURLString.isEmpty else {
            return nil
        }
        
        return URL(string: eventSeatMapURLString)
    }
    
    init(eventId: String,
         apiClient: TicketmasterEventDetailsAPIClientProtocol,
         cacheManager: EventDetailsCacheManaging) {
        self.apiClient = apiClient
        self.cacheManager = cacheManager
        
        Task(priority: .high) {
            await loadEventDetailsFromCache(eventId: eventId)
        }
    }
    
    func loadEventDetailsFromCache(eventId: String) async {
        let result = await cacheManager.getObjectFromCache(for: eventId)
        
        switch result {
        case .success(let eventObjectFromCache):
            event = eventObjectFromCache.eventDetails
        case .failure(_):
            await loadEventDetailsFromAPI()
        }
    }
    
    func loadEventDetailsFromAPI() async {
        isLoading = true
        
        do {
            event = try await apiClient.fetchEventDetails()
            
            if let event = event {
                await saveEventDetailsToCache(eventDetails: event)
            }
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func saveEventDetailsToCache(eventDetails: EventDetails) async {
        await cacheManager.addObjectToCache(
            eventDetails.toObject(),
            for: eventDetails.id
        )
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
