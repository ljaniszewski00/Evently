import SwiftUI

extension Image {
    func toolbarImageModifier(colorScheme: ColorScheme) -> some View {
        self.resizable()
            .scaledToFit()
            .frame(width: Views.Constants.toolbarImageFrameSize,
                   height: Views.Constants.toolbarImageFrameSize)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
            .padding(Views.Constants.toolbarImageInnerPadding)
            .background {
                RoundedRectangle(
                    cornerRadius: Views.Constants.toolbarImageBackgroundCornerRadius
                )
                    .foregroundStyle(.ultraThinMaterial)
            }
            .frame(width: Views.Constants.toolbarImageFrameSizeWithBackground)
    }
    
    func listEventImageModifier() -> some View {
        self.resizable()
            .scaledToFill()
            .frame(minWidth: Views.Constants.listEventFrameMinWidth,
                   maxWidth: .infinity)
            .aspectRatio(Views.Constants.listEventAspectRatio, contentMode: .fill)
            .clipped()
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Views.Constants.listEventClipShapeCornerRadius,
                    style: .continuous
                )
            )
    }
    
    func gridEventImageModifier(frameHeight: CGFloat) -> some View {
        self.resizable()
            .scaledToFill()
            .frame(height: frameHeight, alignment: .center)
    }
}

private extension Views {
    struct Constants {
        static let toolbarImageFrameSize: CGFloat = 17
        static let toolbarImageInnerPadding: CGFloat = 8
        static let toolbarImageBackgroundCornerRadius: CGFloat = 10
        static let toolbarImageFrameSizeWithBackground: CGFloat = 20
        
        static let listEventFrameMinWidth: CGFloat = 0
        static let listEventAspectRatio: CGFloat = 1
        static let listEventClipShapeCornerRadius: CGFloat = 10
    }
}
