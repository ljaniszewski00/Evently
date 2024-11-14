import SwiftUI

struct EventsListView: View {
    @ObservedObject var viewModel: EventsListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.events) { event in
                NavigationLink(destination: EventDetailsView(
                    eventId: event.id
                )) {
                    EventRowView(event: event)
                }
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
        }
        .refreshable {
            await viewModel.loadFirstEvents()
        }
        .alert("Błąd", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Wystąpił nieznany błąd")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .resizable()
                    .scaledToFit()
                    .contextMenu {
                        ForEach(EventsSortingStrategy.allCases, id: \.self) { sortingStrategy in
                            Button {
                                Task {
                                    await viewModel.chooseEventsSortingStrategy(sortingStrategy)
                                }
                            } label: {
                                HStack {
                                    Text(sortingStrategy.name)
                                        .padding(.trailing)
                                    
                                    if viewModel.checkSortingStrategyIsChoosen(sortingStrategy) {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
            }
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
