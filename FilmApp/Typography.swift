import SwiftUI

/// Semantic typography tokens with -2% tracking unless stated otherwise.
enum Typography {
    struct Style {
        let font: Font
        let tracking: CGFloat
        let lineSpacing: CGFloat?
    }

    // -2% tracking applied
    static let titleNav = Style(font: .system(size: 20, weight: .medium),
                                tracking: -0.2,
                                lineSpacing: nil)

    static let pillSegment = Style(font: .system(size: 14, weight: .medium),
                                   tracking: -0.2,
                                   lineSpacing: nil)

    static let sectionTitle = Style(font: .system(size: 26, weight: .semibold),
                                    tracking: -0.2,
                                    lineSpacing: nil)

    static let cardTitle = Style(font: .system(size: 10, weight: .medium),
                                 tracking: -0.2,
                                 lineSpacing: nil)

    static let cardMeta = Style(font: .system(size: 8, weight: .medium),
                                tracking: -0.2,
                                lineSpacing: nil)

    static let storyHeadline = Style(font: .system(size: 16, weight: .medium),
                                     tracking: -0.2,
                                     lineSpacing: nil)

    static let recentStoryTitle = Style(font: .system(size: 16, weight: .semibold),
                                        tracking: -0.2,
                                        lineSpacing: 0)

    static let bodyPrimary = Style(font: .system(size: 14, weight: .medium),
                                   tracking: -0.2,
                                   lineSpacing: 0) // ~18pt line height target

    static let bodySecondary = Style(font: .system(size: 14, weight: .medium),
                                     tracking: -0.2,
                                     lineSpacing: nil)

    static let buttonLabel = Style(font: .system(size: 14, weight: .medium),
                                   tracking: -0.2,
                                   lineSpacing: nil)

    static let starRating = Style(font: .system(size: 10, weight: .medium),
                                  tracking: -0.2,
                                  lineSpacing: nil)

    // Tab label (navbar) — tracking 0 by требование
    static let tabLabel = Style(font: .system(size: 10, weight: .medium),
                                tracking: 0,
                                lineSpacing: nil)

    static let tabTitleLarge = Style(font: .system(size: 17, weight: .medium),
                                     tracking: -0.2,
                                     lineSpacing: nil)
}

extension Text {
    @ViewBuilder
    func typography(_ style: Typography.Style) -> some View {
        let base = self
            .font(style.font)
            .tracking(style.tracking)
        if let spacing = style.lineSpacing {
            base.lineSpacing(spacing)
        } else {
            base
        }
    }
}
