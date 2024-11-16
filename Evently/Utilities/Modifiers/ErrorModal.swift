import SwiftUI

extension View {
    func errorModal(isPresented: Binding<Bool>, errorDescription: String?) -> some View {
        self.modifier(ErrorModal(isPresented: isPresented, errorDescription: errorDescription))
    }
}

struct ErrorModal: ViewModifier {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var stopModalDisappear: Bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var secondsElapsed: Int = 0
    
    private let secondsToElapseToModalDisappear: Int = 4
    
    @Binding var isPresented: Bool
    var errorDescription: String?

    init(isPresented: Binding<Bool>, errorDescription: String?) {
        _isPresented = isPresented
        self.errorDescription = errorDescription
    }

    func body(content: Content) -> some View {
        content
            .overlay(popupContent(), alignment: .top)
    }

    @ViewBuilder private func popupContent() -> some View {
        if isPresented {
            ZStack {
                Rectangle()
                    .foregroundColor(.red)
                
                VStack(spacing: Views.Constants.errorTitleDescriptionVStackSpacing) {
                    Text(Views.Constants.errorModalTitle)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if let errorDescription = errorDescription {
                        Text(errorDescription)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .padding(.top,
                         safeAreaInsets.top + Views.Constants.errorModalContentTopPaddingAdditionalValue)
                .fixedSize(horizontal: false, vertical: true)
            }
            .animation(
                .easeInOut(duration: Views.Constants.animationDuration)
            )
            .transition(.offset(x: Views.Constants.xAxisTransition,
                                y: Views.Constants.yAxisTransition))
            .frame(maxHeight: Views.Constants.errorViewMaxHeight)
            .onTapGesture {
                DispatchQueue.main.async {
                    withAnimation {
                        $isPresented.wrappedValue = false
                    }
                }
            }
            .onReceive(timer) { _ in
                secondsElapsed += 1
                if secondsElapsed == secondsToElapseToModalDisappear && !stopModalDisappear {
                    timer.upstream.connect().cancel()
                    DispatchQueue.main.async {
                        withAnimation {
                            $isPresented.wrappedValue = false
                        }
                    }
                }
            }
            .onDisappear {
                secondsElapsed = 0
                stopModalDisappear = false
            }
            .ignoresSafeArea()
        }
    }
}

private extension Views {
    struct Constants {
        static let backgroundStrokeLineWidth: CGFloat = 3
        static let errorTitleDescriptionVStackSpacing: CGFloat = 8
        static let errorModalTitle: String = "Error"
        static let errorModalContentTopPaddingAdditionalValue: CGFloat = 30
        static let animationDuration: CGFloat = 1.0
        static let delay: DispatchTime = DispatchTime.now() + 3
        static let errorViewMaxHeight: CGFloat = 80
        static let xAxisTransition: CGFloat = 0
        static let yAxisTransition: CGFloat = -UIScreen.main.bounds.height
    }
}
