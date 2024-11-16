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
        .padding(.horizontal, Views.Constants.gridHorizontalPadding)
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
        VStack(spacing: Views.Constants.cellVStackSpacing) {
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
            .aspectRatio(Views.Constants.cellAspectRatio, contentMode: .fit)
            
            VStack(alignment: .leading,
                   spacing: Views.Constants.cellDetailsVStackSpacing) {
                Text(event.name)
                    .font(.subheadline)
                    .fontWeight(.bold)

                VStack(alignment: .leading,
                       spacing: Views.Constants.cellDatePlaceVStackSpacing) {
                    HStack(spacing: Views.Constants.cellDateHStackSpacing) {
                        Image(systemName: Views.Constants.cellDateImage)
                        
                        if let date = event.dateString {
                            Text(date)
                        } else {
                            Text(Views.Constants.cellDateNotAvailable)
                        }
                        
                        Spacer()
                    }
                    
                    HStack(spacing: Views.Constants.cellPlaceHStackSpacing) {
                        Image(systemName: Views.Constants.cellPlaceImage)
                        
                        if let venue = event.embedded.venues.first {
                            VStack(alignment: .leading,
                                   spacing: Views.Constants.cellPlaceVenueVStackSpacing) {
                                Text(venue.name)
                                Text("\(venue.city.name), \(venue.country.name)")
                            }
                            .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text(Views.Constants.cellPlaceNotAvailable)
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, Views.Constants.cellPlaceLeadingPadding)
                }
                .font(.caption2.weight(.semibold))
                .foregroundColor(.secondary)
            }
            .padding(Views.Constants.cellDetailsVStackPadding)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .mask(Rectangle())
            )
        }
        .mask(
            RoundedRectangle(
                cornerRadius: Views.Constants.cellMaskCornerRadius,
                style: .continuous
            )
        )
        .padding(Views.Constants.cellPadding)
        .shadow(radius: Views.Constants.cellShadowRadius)
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
        static let gridHorizontalPadding: CGFloat = 5
        static let gridListRowInsetValue: CGFloat = 0
        
        static let eventGridCellVStackSpacing: CGFloat = 0
        static let eventGridCellImageSize: CGFloat = 120
        
        static let cellVStackSpacing: CGFloat = 0
        static let cellAspectRatio: CGFloat = 1
        static let cellDetailsVStackSpacing: CGFloat = 10
        static let cellDatePlaceVStackSpacing: CGFloat = 5
        
        static let cellDateHStackSpacing: CGFloat = 6
        static let cellDateImage: String = "calendar"
        static let cellDateNotAvailable: String = "Date not available"
        
        static let cellPlaceHStackSpacing: CGFloat = 6
        static let cellPlaceImage: String = "mappin"
        static let cellPlaceVenueVStackSpacing: CGFloat = 2
        static let cellPlaceNotAvailable: String = "Place not available"
        static let cellPlaceLeadingPadding: CGFloat = 1.5
        
        static let cellDetailsVStackPadding: CGFloat = 8
        static let cellMaskCornerRadius: CGFloat = 10
        static let cellPadding: CGFloat = 3
        static let cellShadowRadius: CGFloat = 8
    }
}
