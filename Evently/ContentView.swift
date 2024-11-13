import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EventsListViewModel(
        apiClient: TicketmasterEventsAPIClient()
    )
    
    var body: some View {
        NavigationStack {
            EventsListView(viewModel: viewModel)
                .navigationTitle("Wydarzenia")
        }
    }
}

#Preview {
    ContentView()
}
