import Foundation

@MainActor
final class EventsListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    @Published var displayMode: EventsListDisplayMode = .list
    
    @Published var showEventsSortingSheet: Bool = false
    @Published private var eventsSortingStrategy: EventsSortingStrategy = (.date, .ascending)
    
    private var currentPage = 0
    private let apiClient: TicketmasterEventsAPIClientProtocol
    
    let selectedCountry: Country = .poland
    private let numberOfEventsLoaded: String = "20"
    
    init(apiClient: TicketmasterEventsAPIClientProtocol) {
        self.apiClient = apiClient
        
        Task(priority: .high) {
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
    
    func chooseEventsSortingStrategy(
        sortingKey: EventsSortingKey,
        sortingValue: EventsSortingValue
    ) async {
        let newSortingStrategy = (sortingKey, sortingValue)
        
        guard newSortingStrategy != eventsSortingStrategy else {
            return
        }
        
        eventsSortingStrategy = newSortingStrategy
        await loadFirstEvents()
    }
    
    func toggleDisplayMode() {
        if displayMode == .grid {
            displayMode = .list
        } else {
            displayMode = .grid
        }
    }
    
    private func loadEvents(forPage: Int? = nil) async {
        isLoading = true
        
        let sortingStrategy: String = "\(eventsSortingStrategy.eventsSortingKey.apiCodingName),\(eventsSortingStrategy.eventsSortingValue.apiCodingName)"
        
        do {
            let fetchedEvents = try await apiClient.fetchEvents(
                country: selectedCountry.apiCode,
                page: String(forPage ?? currentPage),
                size: numberOfEventsLoaded,
                with: sortingStrategy
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
