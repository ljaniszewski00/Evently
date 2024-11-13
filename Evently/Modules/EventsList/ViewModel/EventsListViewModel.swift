import Foundation

@MainActor
final class EventsListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private var currentPage = 0
    private let apiClient: TicketmasterEventsAPIClientProtocol = TicketmasterEventsAPIClient()
    
    func loadEvents() async {
        isLoading = true
        
        do {
            events = try await apiClient.fetchEvents(page: currentPage)
            currentPage = 0
        } catch {
            print(error.localizedDescription)
            handleError(error)
        }
        
        isLoading = false
    }
    
    func loadMoreEvents() async {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            let nextPage = try await apiClient.fetchEvents(page: currentPage + 1)
            events.append(contentsOf: nextPage)
            currentPage += 1
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
