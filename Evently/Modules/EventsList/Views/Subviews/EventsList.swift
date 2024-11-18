import SwiftUI

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
                        .listEventImageModifier()
                } placeholder: {
                    Image(.eventImageNotAvailable)
                        .listEventImageModifier()
                        .loadingOverlay()
                }
                
                VStack(alignment: .leading,
                       spacing: Views.Constants.vStackSpacing) {
                    Text(event.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(Views.Constants.eventTitleLineLimit)

                    VStack(alignment: .leading,
                           spacing: Views.Constants.datePlaceVStackSpacing) {
                        HStack(spacing: Views.Constants.dateHStackSpacing) {
                            Image(systemName: Views.Constants.dateImage)
                            
                            if let date = event.dateString {
                                Text(date)
                            } else {
                                Text(Views.Constants.dateNotAvailable)
                            }
                            
                            Spacer()
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)

                        HStack(spacing: Views.Constants.placeHStackSpacing) {
                            Image(systemName: Views.Constants.placeImage)
                            
                            if let venue = event.embedded.venues.first {
                                Text("\(venue.name) • \(venue.city.name)")
                            } else {
                                Text(Views.Constants.placeNotAvailable)
                            }
                            
                            Spacer()
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                        .padding(.leading, Views.Constants.placeLeadingPadding)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(Views.Constants.vStackPadding)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .mask(
                            RoundedRectangle(
                                cornerRadius: Views.Constants.vStackBackgroundCornerRadius,
                                style: .continuous
                            )
                        )
                )
            }
            .padding([.top, .horizontal])
            
            NavigationLink(destination: EventDetailsView(eventId: event.id)) {
                EmptyView()
            }
            .opacity(Views.Constants.navigationLinkOpacity)
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
}

#Preview {
    EventsList(
        viewModel: EventsListViewModel(
            apiClient: TicketmasterEventsAPIClient()
        )
    )
}

private extension Views {
    struct Constants {
        static let vStackSpacing: CGFloat = 10
        static let eventTitleLineLimit: Int = 2
        static let datePlaceVStackSpacing: CGFloat = 5
        
        static let dateHStackSpacing: CGFloat = 4
        static let dateImage: String = "calendar"
        static let dateNotAvailable: String = "Date not available"
        
        static let placeHStackSpacing: CGFloat = 6
        static let placeImage: String = "mappin"
        static let placeNotAvailable: String = "Place not available"
        static let placeLeadingPadding: CGFloat = 2.5
        
        static let vStackPadding: CGFloat = 8
        static let vStackBackgroundCornerRadius: CGFloat = 8
        static let navigationLinkOpacity: CGFloat = 0.0
        
        static let listEventFrameMinWidth: CGFloat = 0
        static let listEventAspectRatio: CGFloat = 1
        static let listEventClipShapeCornerRadius: CGFloat = 10
    }
}

private extension Image {
    func listEventImageModifier() -> some View {
        self.resizable()
            .scaledToFill()
            .frame(minWidth: Views.Constants.listEventFrameMinWidth,
                   maxWidth: .infinity)
            .aspectRatio(Views.Constants.listEventAspectRatio, contentMode: .fill)
            .clipped()
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Views.Constants.listEventClipShapeCornerRadius,
                    style: .continuous
                )
            )
    }
}
