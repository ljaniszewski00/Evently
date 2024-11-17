import SwiftUI

struct EventDetailsView: View {
    @StateObject private var viewModel: EventDetailsViewModel
    
    init(eventId: String) {
        self._viewModel = StateObject(
            wrappedValue: EventDetailsViewModel(
                eventId: eventId,
                apiClient: TicketmasterEventDetailsAPIClient(eventId: eventId)
            )
        )
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let eventDetails = viewModel.event {
                    Views.EventImagesTabView(imagesURLs: viewModel.eventImagesURLs)
                    
                    VStack {
                        Views.EventDetailsDataTile(eventDetails: eventDetails,
                                                   viewModel: viewModel)
                        
                        Views.EventSeatMapTile(seatMapURL: viewModel.eventSeatMapURL)
                    }
                    .padding(.horizontal, Views.Constants.eventDetailsHorizontalPadding)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .ignoresSafeArea()
        .refreshable {
            Task(priority: .high) {
                await viewModel.loadEventDetailsFromAPI()
            }
        }
        .toolbar(viewModel.showError ? .hidden : .visible)
        .errorModal(isPresented: $viewModel.showError,
                    errorDescription: viewModel.errorMessage)
    }
}

#Preview {
    EventDetailsView(
        eventId: Event.sampleEvent.id
    )
}

private extension Views {
    struct Constants {
        static let eventDetailsHorizontalPadding: CGFloat = 10
        
        static let eventImagesTabViewPublishingTimeInterval: TimeInterval = 3
        static let eventImagesTabViewFrameHeight: CGFloat = 400
        static let eventImagesTabViewMaskCornerRadius: CGFloat = 20
        
        static let eventDetailsDataTileNameVStackSpacing: CGFloat = 8
        static let eventDetailsDataTileDividerBottomPadding: CGFloat = 8
        static let eventDetailsDataTileDatePlaceVStackSpacing: CGFloat = 8
        
        static let eventDetailsDataTileDateHStackSpacing: CGFloat = 4
        static let eventDetailsDataTileDateImage: String = "calendar"
        static let eventDetailsDataTileDateNotAvailable: String = "Date not available"
        
        static let eventDetailsDataTilePlaceHStackSpacing: CGFloat = 6
        static let eventDetailsDataTilePlaceImage: String = "mappin"
        static let eventDetailsDataTilePlaceVenueVStackSpacing: CGFloat = 2
        static let eventDetailsDataTilePlaceNotAvailable: String = "Place not available"
        static let eventDetailsDataTilePlaceLeadingPadding: CGFloat = 2
        
        static let eventDetailsDataTilePriceVStackSpacing: CGFloat = 3
        static let eventDetailsDataTilePriceFromLabel: String = "from"
        static let eventDetailsDataTilePriceNotAvailable: String = "Price not available"
        static let eventDetailsDataTilePriceBackgroundCornerRadius: CGFloat = 10
        
        static let eventDetailsDataTileBackgroundCornerRadius: CGFloat = 10
        
        static let eventSeatMapTileVStackSpacing: CGFloat = 15
        static let eventSeatMapTileTitle: String = "Event Seat Map"
        static let eventSeatMapTileMapNotAvailable: String = "Not available"
        static let eventSeatMapTileBackgroundCornerRadius: CGFloat = 10
        
        static let eventSeatMapImageFrameMinWidth: CGFloat = 0
        static let eventSeatMapImageAspectRatio: CGFloat = 1
        static let eventSeatMapImageCornerRadius: CGFloat = 10
    }
    
    struct EventImagesTabView: View {
        @State private var currentImageIndex: Int = 0
        let imagesURLs: [String]
        
        private let timer = Timer.publish(
            every: Views.Constants.eventImagesTabViewPublishingTimeInterval,
            on: .main,
            in: .common
        ).autoconnect()
        
        var body: some View {
            VStack {
                TabView(selection: $currentImageIndex) {
                    ForEach(0..<imagesURLs.count, id: \.self) { imageIndex in
                        ZStack {
                            AsyncImage(url: URL(string: imagesURLs[imageIndex])) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                Image(.eventImageNotAvailable)
                                    .resizable()
                                    .loadingOverlay()
                            }
                            .frame(maxWidth: .infinity)
                            .aspectRatio(contentMode: .fill)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                .onReceive(timer) { _ in
                    changeImageIndexOnTimeElapse()
                }
                .frame(height: Views.Constants.eventImagesTabViewFrameHeight)
                .frame(maxWidth: .infinity)
                .mask(
                    RoundedRectangle(
                        cornerRadius: Views.Constants.eventImagesTabViewMaskCornerRadius
                    )
                )
            }
        }
        
        private func changeImageIndexOnTimeElapse() {
            withAnimation {
                currentImageIndex = (currentImageIndex + 1) % imagesURLs.count
            }
        }
    }
    
    struct EventDetailsDataTile: View {
        let eventDetails: EventDetails
        
        @ObservedObject var viewModel: EventDetailsViewModel
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading,
                           spacing: Views.Constants.eventDetailsDataTileNameVStackSpacing) {
                        Text(eventDetails.name)
                            .font(.title3.weight(.bold))
                        
                        if let eventClassification = viewModel.eventClassificationFormatted {
                            Text(eventClassification)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                        .padding(.bottom, Views.Constants.eventDetailsDataTileDividerBottomPadding)
                    
                    HStack {
                        VStack(alignment: .leading,
                               spacing: Views.Constants.eventDetailsDataTileDatePlaceVStackSpacing) {
                            HStack(spacing: Views.Constants.eventDetailsDataTileDateHStackSpacing) {
                                Image(systemName: Views.Constants.eventDetailsDataTileDateImage)
                                
                                if let dateTime = viewModel.eventDateTimeFormatted {
                                    Text(dateTime)
                                } else {
                                    Text(Views.Constants.eventDetailsDataTileDateNotAvailable)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: Views.Constants.eventDetailsDataTilePlaceHStackSpacing) {
                                Image(systemName: Views.Constants.eventDetailsDataTilePlaceImage)

                                if let venue = eventDetails.embedded.venues.first {
                                    VStack(alignment: .leading,
                                           spacing: Views.Constants.eventDetailsDataTilePlaceVenueVStackSpacing) {
                                        Text(venue.name)
                                        if let address = venue.address.line1 {
                                            Text(address)
                                        }
                                        Text("\(venue.city.name), \(venue.country.name)")
                                    }
                                    .fixedSize(horizontal: false, vertical: true)
                                } else {
                                    Text(Views.Constants.eventDetailsDataTilePlaceNotAvailable)
                                }
                                
                                Spacer()
                            }
                            .padding(.leading, Views.Constants.eventDetailsDataTilePlaceLeadingPadding)
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                        
                        Group {
                            if let minimalPrice = viewModel.eventPriceFormatted {
                                VStack(spacing: Views.Constants.eventDetailsDataTilePriceVStackSpacing) {
                                    Text(Views.Constants.eventDetailsDataTilePriceFromLabel)
                                        .font(.caption2)
                                    Text(minimalPrice)
                                        .font(.headline.weight(.bold))
                                }
                            } else {
                                Text(Views.Constants.eventDetailsDataTilePriceNotAvailable)
                                    .font(.subheadline.weight(.semibold))
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .background (
                            .thinMaterial,
                            in: RoundedRectangle(
                                cornerRadius: Views.Constants.eventDetailsDataTilePriceBackgroundCornerRadius
                            )
                        )
                    }
                }
            }
            .padding()
            .background (
                .ultraThinMaterial,
                in: RoundedRectangle(
                    cornerRadius: Views.Constants.eventDetailsDataTileBackgroundCornerRadius
                )
            )
        }
    }
    
    struct EventSeatMapTile: View {
        let seatMapURL: URL?
        
        var body: some View {
            VStack(alignment: .leading,
                   spacing: Views.Constants.eventSeatMapTileVStackSpacing) {
                HStack {
                    Text(Views.Constants.eventSeatMapTileTitle)
                        .font(.headline.weight(.semibold))
                    
                    Spacer()
                }
                
                if let seatMapURL = seatMapURL {
                    AsyncImage(url: seatMapURL) { image in
                        image
                            .eventSeatMapImageModifier()
                    } placeholder: {
                        Image(.eventImageNotAvailable)
                            .eventSeatMapImageModifier()
                            .loadingOverlay()
                    }
                } else {
                    HStack {
                        Text(Views.Constants.eventSeatMapTileMapNotAvailable)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background (
                .ultraThinMaterial,
                in: RoundedRectangle(
                    cornerRadius: Views.Constants.eventSeatMapTileBackgroundCornerRadius
                )
            )
        }
    }
}

private extension Image {
    func eventSeatMapImageModifier() -> some View {
        self.resizable()
            .scaledToFill()
            .frame(minWidth: Views.Constants.eventSeatMapImageFrameMinWidth,
                   maxWidth: .infinity)
            .aspectRatio(Views.Constants.eventSeatMapImageAspectRatio,
                         contentMode: .fill)
            .clipped()
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Views.Constants.eventSeatMapImageCornerRadius,
                    style: .continuous
                )
            )
    }
}
