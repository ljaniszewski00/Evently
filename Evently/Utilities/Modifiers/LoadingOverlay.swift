import SwiftUI

extension View {
    func loadingOverlay() -> some View {
        self.overlay {
            ZStack {
                Color.black.opacity(0.8)
                ProgressView()
            }
        }
    }
} 
