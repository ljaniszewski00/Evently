import SwiftUI

struct EventsListView: View {
    @ObservedObject var viewModel: EventsListViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            List {
                switch viewModel.displayMode {
                case .list:
                    EventsList(viewModel: viewModel)
                case .grid:
                    EventsGrid(viewModel: viewModel)
                }
                
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        Task {
                            await viewModel.loadMoreEvents()
                        }
                    }
                    .listRowBackground(
                        EmptyView()
                    )
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .refreshable {
                Task {
                    await viewModel.loadFirstEvents()
                }
            }
        }
        .navigationTitle("")
        .toolbar(viewModel.showError ? .hidden : .visible)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                VStack(alignment: .leading) {
                    Text("All events in")
                        .font(.footnote)
                    Text("Poland")
                        .font(.title.weight(.bold))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showEventsSortingSheet = true
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .toolbarImageModifier(colorScheme: colorScheme)
                        
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                let imageName: String = viewModel.displayMode == .grid ?
                EventsListDisplayMode.list.displayModeIconName : EventsListDisplayMode.grid.displayModeIconName
                
                Button {
                    viewModel.toggleDisplayMode()
                } label: {
                    Image(systemName: imageName)
                        .toolbarImageModifier(colorScheme: colorScheme)
                }
            }
        }
        .errorModal(isPresented: $viewModel.showError,
                    errorDescription: viewModel.errorMessage)
        .sheet(isPresented: $viewModel.showEventsSortingSheet) {
            EventsSortingSheetView(eventsListViewModel: viewModel)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    EventsListView(
        viewModel: EventsListViewModel(
            apiClient: TicketmasterEventsAPIClient()
        )
    )
}

private extension Views {
    struct Constants {
        
    }
}
