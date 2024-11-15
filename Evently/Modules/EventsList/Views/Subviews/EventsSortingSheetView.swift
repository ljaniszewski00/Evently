import SwiftUI

struct EventsSortingSheetView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @ObservedObject var eventsListViewModel: EventsListViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(EventsSortingKey.allCases) { sortingKey in
                        Text(sortingKey.rawValue)
                            .font(.title2.weight(.bold))
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(sortingKey.availableSortingValues) { sortingValue in
                                Button {
                                    Task {
                                        await eventsListViewModel.chooseEventsSortingStrategy(
                                            sortingKey: sortingKey,
                                            sortingValue: sortingValue
                                        )
                                    }
                                    dismiss()
                                } label: {
                                    let availableSortingStrategy: EventsSortingStrategy = (sortingKey, sortingValue)
                                    
                                    HStack {
                                        Circle()
                                            .if(!eventsListViewModel.checkSortingStrategyIsChoosen(availableSortingStrategy)) {
                                                $0.stroke(lineWidth: 1)
                                            }
                                            .frame(width: 15, height: 15)
                                        
                                        Text(sortingValue.rawValue.lowercased())
                                            .fontWeight(.medium)
                                        Spacer()
                                    }
                                }
                                .tint(colorScheme == .dark ? .white : .black)
                            }
                        }
                        
                        Divider()
                    }
                }
                .padding()
            }
            .navigationTitle("Sort Events By")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EventsSortingSheetView(
        eventsListViewModel: EventsListViewModel(
            apiClient: TicketmasterEventsAPIClient()
        )
    )
}
