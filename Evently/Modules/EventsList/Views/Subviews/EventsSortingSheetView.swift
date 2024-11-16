import SwiftUI

struct EventsSortingSheetView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @ObservedObject var eventsListViewModel: EventsListViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading,
                       spacing: Views.Constants.mainVStackSpacing) {
                    ForEach(EventsSortingKey.allCases) { sortingKey in
                        Text(sortingKey.rawValue)
                            .font(.title2.weight(.bold))
                        VStack(alignment: .leading,
                               spacing: Views.Constants.innerVStackSpacing) {
                            ForEach(sortingKey.availableSortingValues) { sortingValue in
                                Button {
                                    Task {
                                        await eventsListViewModel.chooseEventsSortingStrategy(
                                            sortingKey: sortingKey,
                                            sortingValue: sortingValue
                                        )
                                        
                                        dismiss()
                                    }
                                } label: {
                                    let availableSortingStrategy: EventsSortingStrategy = (sortingKey, sortingValue)
                                    
                                    HStack {
                                        Circle()
                                            .if(!eventsListViewModel.checkSortingStrategyIsChoosen(availableSortingStrategy)) {
                                                $0.stroke(
                                                    lineWidth: Views.Constants.notSelectedSortingValueCircleStrokeLineWidth
                                                )
                                            }
                                            .frame(width: Views.Constants.sortingValueCircleSize,
                                                   height: Views.Constants.sortingValueCircleSize)
                                        
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
            .navigationTitle(Views.Constants.navigationTitle)
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

private extension Views {
    struct Constants {
        static let mainVStackSpacing: CGFloat = 15
        static let innerVStackSpacing: CGFloat = 10
        static let notSelectedSortingValueCircleStrokeLineWidth: CGFloat = 1
        static let sortingValueCircleSize: CGFloat = 15
        static let navigationTitle: String = "Sort Events By"
    }
}
