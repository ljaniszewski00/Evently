import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EventsListViewModel()
    
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
