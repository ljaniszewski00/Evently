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
                        Task(priority: .high) {
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
                Task(priority: .high) {
                    await viewModel.loadFirstEvents()
                }
            }
        }
        .navigationTitle(Views.Constants.navigationTitle)
        .toolbar(viewModel.showError ? .hidden : .visible)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                VStack(alignment: .leading) {
                    Text(Views.Constants.toolbarTitleFirstLine)
                        .font(.footnote)
                    Text(viewModel.selectedCountry.name)
                        .font(.title.weight(.bold))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showEventsSortingSheet = true
                } label: {
                    Image(systemName: Views.Constants.toolbarSortingButtonImage)
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
        static let navigationTitle: String = ""
        static let toolbarTitleFirstLine: String = "All events in"
        static let toolbarSortingButtonImage: String = "arrow.up.arrow.down"
        
        static let toolbarImageFrameSize: CGFloat = 17
        static let toolbarImageInnerPadding: CGFloat = 8
        static let toolbarImageBackgroundCornerRadius: CGFloat = 10
        static let toolbarImageFrameSizeWithBackground: CGFloat = 20
    }
}

private extension Image {
    func toolbarImageModifier(colorScheme: ColorScheme) -> some View {
        self.resizable()
            .scaledToFit()
            .frame(width: Views.Constants.toolbarImageFrameSize,
                   height: Views.Constants.toolbarImageFrameSize)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
            .padding(Views.Constants.toolbarImageInnerPadding)
            .background {
                RoundedRectangle(
                    cornerRadius: Views.Constants.toolbarImageBackgroundCornerRadius
                )
                    .foregroundStyle(.ultraThinMaterial)
            }
            .frame(width: Views.Constants.toolbarImageFrameSizeWithBackground)
    }
}
