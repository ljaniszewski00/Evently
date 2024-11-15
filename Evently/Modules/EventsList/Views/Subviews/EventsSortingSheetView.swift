import SwiftUI

struct EventsSortingSheetView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(EventsSortingValue.allCases) { sortingValue in
                        Text("by \(sortingValue.rawValue)")
                            .font(.title2.weight(.bold))
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(sortingValue.availableSortingTypes) { sortingType in
                                HStack {
                                    Text(sortingType.rawValue.lowercased())
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                            }
                        }
                        
                        Divider()
                    }
                }
                .padding()
            }
            .navigationTitle("Sort Events")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EventsSortingSheetView()
}
