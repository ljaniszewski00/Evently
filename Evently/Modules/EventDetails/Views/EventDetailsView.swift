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
                    Views.EventImagesTabView(imagesURLs: viewModel.eventImagesURLs)
                }
            }
        }
        .ignoresSafeArea()
        .refreshable {
            await viewModel.loadEventDetailsFromAPI()
        }
        .alert("Błąd", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Wystąpił nieznany błąd")
        }
    }
    
    private var priceRange: String {
        guard let prices = viewModel.event?.priceRanges?.first else {
            return "Cena niedostępna"
        }
        return "od \(String(format: "%.2f", prices.min)) \(prices.currency)"
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
                            }
                            .frame(maxWidth: .infinity)
                            .aspectRatio(contentMode: .fill)
                            .overlay {
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        .clear,
                                        .black.opacity(0.5),
                                        .black
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
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
            }
        }
        
        private func changeImageIndexOnTimeElapse() {
            withAnimation {
                currentImageIndex = (currentImageIndex + 1) % imagesURLs.count
            }
        }
    }
}
