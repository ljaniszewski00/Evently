import Foundation

@MainActor
final class EventDetailsViewModel: ObservableObject {
    @Published var event: EventDetails?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private let apiClient: TicketmasterEventDetailsAPIClientProtocol
    
    init(eventId: String,
         apiClient: TicketmasterEventDetailsAPIClientProtocol) {
        self.apiClient = TicketmasterEventDetailsAPIClient(eventId: eventId)
        
        Task {
            await loadEventDetailsFromAPI()
        }
    }
    
    func loadEventDetailsFromAPI() async {
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
