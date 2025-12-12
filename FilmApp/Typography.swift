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
    // Used for the Letterboxd header in the feed.

    static let sectionTitle = Style(font: .system(size: 24, weight: .semibold),
                                    tracking: -0.2,
                                    lineSpacing: nil)
    // Section headers like “Lists”, “Recent stories”, and “Reviews”, plus FilmPage titles.

    static let cardTitle = Style(font: .system(size: 10, weight: .medium),
                                 tracking: -0.2,
                                 lineSpacing: nil)
    // Friend card names, detail labels, and small rating text.

    static let cardMeta = Style(font: .system(size: 8, weight: .medium),
                                tracking: -0.2,
                                lineSpacing: nil)
    // Reserved for future metadata badges.

    static let storyHeadline = Style(font: .system(size: 16, weight: .medium),
                                     tracking: -0.2,
                                     lineSpacing: nil)
    // Review author names inside each review card.

    static let recentStoryTitle = Style(font: .system(size: 16, weight: .semibold),
                                        tracking: -0.2,
                                        lineSpacing: 0)
    // Headlines shown on story preview cards.

    static let bodyPrimary = Style(font: .system(size: 14, weight: .medium),
                                   tracking: -0.2,
                                   lineSpacing: 0)
    // Review bodies, FilmPage info labels, and other medium-weight copy requiring line spacing control.

    static let filmInfoRating = Style(font: .system(size: 12, weight: .medium),
                                      tracking: -0.2,
                                      lineSpacing: nil)
    // Rating text shown inside the Film info card bar.

    static let bodySecondary = Style(font: .system(size: 14, weight: .medium),
                                     tracking: -0.2,
                                     lineSpacing: nil)
    // Segment labels and other medium copy where default line spacing is fine.

    // Tab label (navbar) — tracking 0 by требование
    static let tabLabel = Style(font: .system(size: 10, weight: .medium),
                                tracking: 0,
                                lineSpacing: nil)
    // Tab bar text labels.

    static let tabTitleLarge = Style(font: .system(size: 17, weight: .medium),
                                     tracking: -0.2,
                                     lineSpacing: nil)
    // For possible future tab titles needing larger type.

    // Shared icon fonts (tracking 0 to keep glyph dimensions predictable).
    static let sectionAccessoryIcon = Style(font: .system(size: 17, weight: .medium),
                                            tracking: 0,
                                            lineSpacing: nil)
    // Section chevrons and similar accessory glyphs.

    static let ratingStarIcon = Style(font: .system(size: 9, weight: .medium),
                                      tracking: 0,
                                      lineSpacing: nil)
    // Rating stars that appear in friend/review rows.

    static let badgeIcon = Style(font: .system(size: 12, weight: .medium),
                                 tracking: 0,
                                 lineSpacing: nil)
    // Small badge icons such as the heart/likes indicator.

    static let tabIcon = Style(font: .system(size: 17, weight: .regular),
                               tracking: 0,
                               lineSpacing: nil)
    // Floating glass button and regular tab icons.

    static let tabIconProfile = Style(font: .system(size: 20, weight: .regular),
                                      tracking: 0,
                                      lineSpacing: nil)
    // Profile tab icon (keeps the larger glyph under a named style).

    static let searchIcon = Style(font: .system(size: 21, weight: .regular),
                                  tracking: 0,
                                  lineSpacing: nil)
    // Magnifying glass inside the search button.
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
