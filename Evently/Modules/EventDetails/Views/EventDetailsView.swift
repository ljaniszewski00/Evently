import SwiftUI

struct EventDetailsView: View {
    @StateObject private var viewModel: EventDetailsViewModel
    
    @Namespace var namespace: Namespace.ID
    
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
                    if !viewModel.eventImagesURLs.isEmpty {
                        Views.EventImagesTabView(imagesURLs: viewModel.eventImagesURLs)
                    }
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(eventDetails.name)
                                        .font(.title3.weight(.bold))
                                    
                                    if let eventClassification = viewModel.eventClassificationFormatted {
                                        Text(eventClassification)
                                            .font(.caption.weight(.semibold))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Divider()
                                    .padding(.bottom, 8)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "calendar")
                                            
                                            if let dateTime = viewModel.eventDateTimeFormatted {
                                                Text(dateTime)
                                            } else {
                                               Text("Date not available")
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        HStack(spacing: 6) {
                                            Image(systemName: "mappin")

                                            if let venue = eventDetails.embedded.venues.first {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(venue.name)
                                                    if let address = venue.address.line1 {
                                                        Text(address)
                                                    }
                                                    Text("\(venue.city.name), \(venue.country.name)")
                                                }
                                                .fixedSize(horizontal: false, vertical: true)
                                            } else {
                                                Text("Place not available")
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.leading, 2)
                                    }
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(.secondary)
                                    
                                    Group {
                                        if let minimalPrice = viewModel.eventPriceFormatted {
                                            VStack(spacing: 3) {
                                                Text("from")
                                                    .font(.caption2)
                                                Text(minimalPrice)
                                                    .font(.headline.weight(.bold))
                                            }
                                        } else {
                                            Text("Price not available")
                                                .font(.subheadline.weight(.semibold))
                                        }
                                    }
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding()
                                    .background (
                                        .thinMaterial,
                                        in: RoundedRectangle(cornerRadius: 10)
                                    )
                                }
                            }
                        }
                        .padding()
                        .background (
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Event Seat Map")
                                    .font(.headline.weight(.semibold))
                                
                                Spacer()
                            }
                            
                            if let seatMapURL = viewModel.eventSeatMapURL {
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
                                    Text("Not Available")
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
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                    }
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .ignoresSafeArea()
        .refreshable {
            Task {
                await viewModel.loadEventDetailsFromAPI()
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Unknow error occured")
        }
    }
}

#Preview {
    EventDetailsView(
        eventId: "5"
    )
}

private extension Views {
    struct Constants {
        static let imagePlaceholderName: String = "person.crop.circle.fill"
    }
    
    struct EventImagesTabView: View {
        @State private var currentImageIndex: Int = 0
        let imagesURLs: [String]
        
        private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        
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
                .frame(height: 400)
                .frame(maxWidth: .infinity)
                .mask(RoundedRectangle(cornerRadius: 20))
            }
        }
        
        private func changeImageIndexOnTimeElapse() {
            withAnimation {
                currentImageIndex = (currentImageIndex + 1) % imagesURLs.count
            }
        }
    }
}

private extension Image {
    func eventSeatMapImageModifier() -> some View {
        self.resizable()
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
