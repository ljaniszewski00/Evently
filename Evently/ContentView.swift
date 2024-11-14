import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EventsListViewModel(
        apiClient: TicketmasterEventsAPIClient()
    )
    
    var body: some View {
        NavigationStack {
            EventsListView(viewModel: viewModel)
                .navigationTitle(Views.Constants.navigationTitle)
        }
    }
}

#Preview {
    ContentView()
}

private extension Views {
    struct Constants {
        static let navigationTitle: String = "Events"
    }
}
