import Foundation

@MainActor
final class EventsListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    @Published private var eventsSortingStrategy: EventsSortingStrategy = .dateAscending
    
    private var currentPage = 0
    private let apiClient: TicketmasterEventsAPIClientProtocol
    
    init(apiClient: TicketmasterEventsAPIClientProtocol) {
        self.apiClient = apiClient
        
        Task {
            await loadFirstEvents()
        }
    }
    
    func loadFirstEvents() async {
        guard !isLoading else { return }
        
        events.removeAll()
        
        await loadEvents(
            forPage: 0
        )
    }
    
    func loadMoreEvents() async {
        guard !isLoading else { return }
        
        currentPage += 1
        
        await loadEvents()
    }
    
    func checkSortingStrategyIsChoosen(_ sortingStrategy: EventsSortingStrategy) -> Bool {
        sortingStrategy == eventsSortingStrategy
    }
    
    func chooseEventsSortingStrategy(_ newSortingStrategy: EventsSortingStrategy) async {
        eventsSortingStrategy = newSortingStrategy
        await loadFirstEvents()
    }
    
    private func loadEvents(forPage: Int? = nil) async {
        isLoading = true
        
        do {
            let fetchedEvents = try await apiClient.fetchEvents(
                page: forPage ?? currentPage,
                with: eventsSortingStrategy
            )
            
            events.append(contentsOf: fetchedEvents)
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
