import SwiftUI

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
                EventsGridCell(
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
        .padding(.horizontal, 5)
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
            GeometryReader { geometry in
                AsyncImage(url: URL(string: event.images.first?.url ?? "")) { image in
                    image
                        .gridEventImageModifier(frameHeight: geometry.size.width)
                } placeholder: {
                    Image(.eventImageNotAvailable)
                        .gridEventImageModifier(frameHeight: geometry.size.width)
                        .loadingOverlay()
                }
            }
            .clipped()
            .aspectRatio(1, contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(event.name)
                    .font(.subheadline)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 5) {
                    if let date = event.dateString {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                            Text(date)
                            Spacer()
                        }
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
                        .padding(.leading, 1.5)
                    }
                }
                .font(.caption2.weight(.semibold))
                .foregroundColor(.secondary)
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
        .shadow(radius: 8)
    }
}

#Preview {
    EventsGrid(
        viewModel: EventsListViewModel(
            apiClient: TicketmasterEventsAPIClient()
        )
    )
}

private extension Views {
    struct Constants {
        static let gridItemMinimumSize: CGFloat = 50
        static let navigationLinkOpacity: CGFloat = 0.0
        static let gridListRowInsetValue: CGFloat = 0
        static let eventGridCellVStackSpacing: CGFloat = 0
        static let eventGridCellImageSize: CGFloat = 120
    }
}
