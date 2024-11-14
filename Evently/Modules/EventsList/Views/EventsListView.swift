import SwiftUI

struct EventsListView: View {
    @ObservedObject var viewModel: EventsListViewModel
    
    var body: some View {
        VStack {
            List {
                switch viewModel.displayMode {
                case .list:
                    Views.EventsList(viewModel: viewModel)
                case .grid:
                    Views.EventsGrid(viewModel: viewModel)
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
            .refreshable {
                await viewModel.loadFirstEvents()
            }
            .alert("Błąd", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Wystąpił nieznany błąd")
            }
            .navigationTitle(Views.Constants.navigationTitleFullList)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    let imageName: String = viewModel.displayMode == .grid ?
                    EventsListDisplayMode.list.displayModeIconName : EventsListDisplayMode.grid.displayModeIconName
                    
                    Button {
                        viewModel.toggleDisplayMode()
                    } label: {
                        Image(systemName: imageName)
                            .foregroundStyle(.white)
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

private extension Views {
    struct Constants {
        static let navigationTitleFullList: String = "Events"
        
        static let eventListCellOuterHStackSpacing: CGFloat = 10
        static let eventListCellInnerHStackSpacing: CGFloat = 15
        static let eventListCellOuterHStackPadding: CGFloat = 5
        
        static let gridItemMinimumSize: CGFloat = 50
        static let navigationLinkOpacity: CGFloat = 0.0
        static let gridListRowInsetValue: CGFloat = 0
        static let eventListCellImageSize: CGFloat = 80
        static let eventListCellImageRadius: CGFloat = 10
        static let eventGridCellVStackSpacing: CGFloat = 0
        static let eventGridCellImageSize: CGFloat = 120
        static let imagePlaceholderName: String = "person.crop.circle.fill"
        static let favoriteImageWidth: CGFloat = 20
        static let favoriteImageHeight: CGFloat = 17
        static let favoriteImageBackgroundPadding: CGFloat = 10
        static let favoriteImageXOffset: CGFloat = 15
        static let eventNameBackgroundPadding: CGFloat = 10
        static let eventNameHorizontalPadding: CGFloat = 5
        static let eventNameYOffset: CGFloat = -15
    }
    
    struct EventsList: View {
        @ObservedObject var viewModel: EventsListViewModel
        
        var body: some View {
            ForEach(viewModel.events) { event in
                EventsListCell(viewModel: viewModel, event: event)
            }
        }
    }
    
    struct EventsListCell: View {
        @ObservedObject var viewModel: EventsListViewModel
        let event: Event
        
        var body: some View {
            NavigationLink {
                EventDetailsView(eventId: event.id)
            } label: {
                HStack(spacing: Views.Constants.eventListCellOuterHStackSpacing) {
                    AsyncImage(url: URL(string: event.images.first?.url ?? "")) { image in
                        image
                            .listEventImageModifier()
                    } placeholder: {
                        Image(systemName: Views.Constants.imagePlaceholderName)
                            .listEventImageModifier()
                    }
                    
                    HStack(spacing: Views.Constants.eventListCellInnerHStackSpacing) {
                        Text(event.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                    }
                    .padding([.top, .leading],
                             Views.Constants.eventListCellOuterHStackPadding)
                }
            }

        }
    }
    
    struct EventsGrid: View {
        @ObservedObject var viewModel: EventsListViewModel
        
        @State var selectedEvent: Event?
        
        private let columns: [GridItem] = [
            GridItem(.flexible(minimum: Views.Constants.gridItemMinimumSize)),
            GridItem(.flexible(minimum: Views.Constants.gridItemMinimumSize))
        ]
        
        var body: some View {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.events, id: \.id) { event in
                    Views.EventsGridCell(
                        viewModel: viewModel,
                        event: event
                    )
                        .background {
                            NavigationLink(
                                destination: EventDetailsView(eventId: event.id),
                                tag: event,
                                selection: $selectedEvent,
                                label: {
                                    EmptyView()
                            })
                            .opacity(Views.Constants.navigationLinkOpacity)
                        }
                        .onTapGesture {
                            selectedEvent = event
                        }
                }
            }
            .padding(.top)
            .listRowInsets(.init(
                top: Views.Constants.gridListRowInsetValue,
                leading: Views.Constants.gridListRowInsetValue,
                bottom: Views.Constants.gridListRowInsetValue,
                trailing: Views.Constants.gridListRowInsetValue
            ))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden)
        }
    }
    
    struct EventsGridCell: View {
        @ObservedObject var viewModel: EventsListViewModel
        let event: Event
        
        var body: some View {
            VStack(spacing: Views.Constants.eventGridCellVStackSpacing) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: event.images.first?.url ?? "")) { image in
                        image
                            .gridEventImageModifier()
                    } placeholder: {
                        Image(systemName: Views.Constants.imagePlaceholderName)
                            .gridEventImageModifier()
                    }
                }
                
                Text(event.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(Views.Constants.eventNameBackgroundPadding)
                    .padding(.horizontal, Views.Constants.eventNameHorizontalPadding)
                    .background(
                        .ultraThinMaterial,
                        in: Capsule()
                    )
                    .offset(y: Views.Constants.eventNameYOffset)
            }
        }
    }
}

private extension Image {
    func listEventImageModifier() -> some View {
        self.resizable()
            .frame(width: Views.Constants.eventListCellImageSize,
                   height: Views.Constants.eventListCellImageSize)
            .clipShape(RoundedRectangle(cornerRadius: Views.Constants.eventListCellImageRadius))
    }
    
    func gridEventImageModifier() -> some View {
        self.resizable()
            .frame(width: Views.Constants.eventGridCellImageSize,
                   height: Views.Constants.eventGridCellImageSize)
            .clipShape(Circle())
    }
}
