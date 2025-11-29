import SwiftUI

struct LiquidGlassModifier<S: InsettableShape>: ViewModifier {
    let shape: S
    let strokeColor: Color?
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .clipShape(shape)
            .background {
                if #available(iOS 26, *) {
                    shape
                        .fill(Color.clear)
                        .glassEffect(.regular)
                } else {
                    shape
                        .fill(.ultraThinMaterial)
                }
            }
            .overlay(alignment: .center) {
                if let strokeColor, lineWidth > 0 {
                    shape
                        .strokeBorder(strokeColor, lineWidth: lineWidth)
                }
            }
        }
    }

extension View {
    func liquidGlass<S: InsettableShape>(
        shape: S,
        strokeColor: Color? = nil,
        lineWidth: CGFloat = 1
    ) -> some View {
        modifier(LiquidGlassModifier(shape: shape,
                                     strokeColor: strokeColor,
                                     lineWidth: strokeColor != nil ? lineWidth : 0))
    }
}
