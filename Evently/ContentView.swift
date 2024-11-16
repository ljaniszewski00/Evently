import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @StateObject private var viewModel = EventsListViewModel(
        apiClient: TicketmasterEventsAPIClient()
    )
    
    var body: some View {
        NavigationStack {
            EventsListView(viewModel: viewModel)
                .navigationTitle(Views.Constants.navigationTitle)
        }
        .accentColor(colorScheme == .dark ? .white : .black)
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
