import SwiftUI

struct EventsListView: View {
    @ObservedObject var viewModel: EventsListViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
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
            .navigationTitle("")
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
                    Image(systemName: "arrow.up.arrow.down")
                        .toolbarImageModifier(colorScheme: colorScheme)
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
                            .toolbarImageModifier(colorScheme: colorScheme)
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
            ZStack {
                ZStack(alignment: .bottom) {
                    AsyncImage(url: URL(string: event.images.first?.url ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    } placeholder: {
                        Image(.eventImageNotAvailable)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(event.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(2)

                        VStack(alignment: .leading, spacing: 5) {
                            if let date = event.dateString {
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                    Text(date)
                                    Spacer()
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }

                            if let venue = event.embedded.venues.first {
                                HStack(spacing: 6) {
                                    Image(systemName: "mappin")
                                    Text("\(venue.name) • \(venue.city.name), \(venue.country.name)")
                                    Spacer()
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    )
                }
                .padding([.top, .horizontal])
                
                NavigationLink(destination: EventDetailsView(eventId: event.id)) {
                    EmptyView()
                }
                .opacity(0.0)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
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
            VStack(spacing: 0) {
                AsyncImage(url: URL(string: event.images.first?.url ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Rectangle())
                } placeholder: {
                    Image(.eventImageNotAvailable)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Rectangle())
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(event.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(2)

                    VStack(alignment: .leading, spacing: 5) {
                        if let date = event.dateString {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                Text(date)
                                Spacer()
                            }
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        }

                        if let venue = event.embedded.venues.first {
                            HStack(spacing: 6) {
                                Image(systemName: "mappin")
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(venue.name)
                                    Text("\(venue.city.name), \(venue.country.name)")
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                    
                                Spacer()
                            }
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(8)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .mask(Rectangle())
                )
            }
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(3)
        }
    }
}

private extension Image {
    func toolbarImageModifier(colorScheme: ColorScheme) -> some View {
        self.resizable()
            .scaledToFit()
            .frame(width: 17, height: 17)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.ultraThinMaterial)
            }
    }
    
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
