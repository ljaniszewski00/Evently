import SwiftUI

struct EventRowView: View {
    let event: Event
    
    private var thumbnailURL: URL? {
        guard let imageUrl = event.images.first?.url else { return nil }
        return URL(string: imageUrl)
    }
    
    private var formattedDate: String {
        guard let date = DateFormatter.eventDateFormatter.date(from: event.dates.startDate.localDate) else {
            return "Data niedostępna"
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: thumbnailURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let placeName = event.place?.name {
                    Text(placeName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
