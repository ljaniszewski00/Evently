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
        List {
            if let event = viewModel.event {
                VStack(alignment: .leading, spacing: 16) {
                    // Galeria zdjęć
                    TabView {
                        ForEach(event.images, id: \.url) { image in
                            AsyncImage(url: URL(string: image.url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                        }
                    }
                    .frame(height: 300)
                    .tabViewStyle(PageTabViewStyle())
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(event.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(formattedDateTime)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Lokalizacja")
                                .font(.headline)
                            
                            if let place = event.place {
                                Text(place.name)
                                if let address = place.address.line1 {
                                    Text(address)
                                }
                            }
                            
                        }
                        
                        Text("Ceny biletów")
                            .font(.headline)
                        Text(priceRange)
                    }
                    .padding()
                }
                .listRowBackground(EmptyView())
                .listRowSeparator(.hidden)
            }
        }
        .refreshable {
            await viewModel.loadEventDetailsFromAPI()
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Błąd", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Wystąpił nieznany błąd")
        }
        
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
        }
    }
    
    private var formattedDateTime: String {
        guard let fetchedDate = viewModel.event?.dates.startDate.localDate,
              let date = DateFormatter.eventDateFormatter.date(from: fetchedDate) else {
            return "Data niedostępna"
        }
        
        let dateString = DateFormatter.displayDateFormatter.string(from: date)
        
        if let fetchedTime = viewModel.event?.dates.startDate.localTime,
           let time = DateFormatter.eventDateFormatter.date(from: fetchedTime) {
            return "\(DateFormatter.displayTimeFormatter.string(from: time)) \(dateString)"
        }
        
        return dateString
    }
    
    private var priceRange: String {
        guard let prices = viewModel.event?.priceRanges?.first else {
            return "Cena niedostępna"
        }
        return "od \(String(format: "%.2f", prices.min)) \(prices.currency)"
    }
}
