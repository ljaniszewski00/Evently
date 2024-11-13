import Foundation

@MainActor
final class EventDetailsViewModel: ObservableObject {
    @Published var event: EventDetails?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private let apiClient: TicketmasterEventDetailsAPIClientProtocol
    
    init(eventId: String) {
        self.apiClient = TicketmasterEventDetailsAPIClient(eventId: eventId)
    }
    
    func loadEventDetails() async {
        isLoading = true
        
        do {
            event = try await apiClient.fetchEventDetails()
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
