import Foundation

@MainActor
final class EventsListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private var currentPage = 0
    private let apiClient: TicketmasterEventsAPIClientProtocol
    
    init(apiClient: TicketmasterEventsAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func loadEvents(forPage: Int? = nil) async {
        isLoading = true
        
        do {
            let fetchedEvents = try await apiClient.fetchEvents(page: forPage ?? currentPage)
            events.append(contentsOf: fetchedEvents)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func loadMoreEvents() async {
        guard !isLoading else { return }
        
        currentPage += 1
        
        await loadEvents()
    }
    
    func checkEventIsLastEvent(_ event: Event) -> Bool? {
        events.last?.id == event.id
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
