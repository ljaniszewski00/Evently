import Foundation
import SwiftUI

@MainActor
final class EventDetailsViewModel: ObservableObject {
    @Published var event: EventDetails?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private let apiClient: TicketmasterEventDetailsAPIClientProtocol
    private let cacheManager = EventDetailsCacheManager.shared
    
    init(eventId: String,
         apiClient: TicketmasterEventDetailsAPIClientProtocol) {
        self.apiClient = TicketmasterEventDetailsAPIClient(eventId: eventId)
        
        loadEventDetailsFromCache(eventId: eventId)
    }
    
    func loadEventDetailsFromCache(eventId: String) {
        let result = cacheManager.getObjectFromCache(for: eventId)
        
        switch result {
        case .success(let eventObjectFromCache):
            event = eventObjectFromCache.eventDetails
        case .failure(_):
            Task {
                await loadEventDetailsFromAPI()
            }
        }
    }
    
    func loadEventDetailsFromAPI() async {
        isLoading = true
        
        do {
            event = try await apiClient.fetchEventDetails()
            
            if let event = event {
                saveEventDetailsToCache(eventDetails: event)
            }
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func saveEventDetailsToCache(eventDetails: EventDetails) {
        cacheManager.addObjectToCache(
            eventDetails.toObject(),
            for: eventDetails.id
        )
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
