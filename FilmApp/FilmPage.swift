import SwiftUI
import UIKit

private enum FilmPageLayout {
    static let horizontalInset: CGFloat = FeedLayout.sectionHorizontalInset
    static let topInset: CGFloat = 18
    static let sectionStackSpacing: CGFloat = FeedLayout.sectionStackSpacing
}

private enum FilmPageInfoLayout {
    static let cardInfoSpacing: CGFloat = 18 // Horizontal gap between the poster card and info column.
    static let cardSynopsisSpacing: CGFloat = 14 // Vertical gap between the card/info row and the synopsis block.
    static let titleInfoSpacing: CGFloat = 10 // Vertical gap between the film title and the info column.
    static let infoBlockSpacing: CGFloat = 4 // Vertical gap between each line inside the info stack.
    static let cardCornerRadius: CGFloat = 8 // Radius for the poster card and the rating plaque.
}

private enum FilmCarouselLayout {
    static let cardWidth: CGFloat = 292 // Width of each carousel card.
    static let cardHeight: CGFloat = 166 // Height of each carousel card.
    static let cardSpacing: CGFloat = 6 // Horizontal spacing between carousel cards.
}

struct FilmPage: View {
    var onClose: () -> Void = {}
    var onOpenLink: () -> Void = {}
    @State private var selectedTab: Tab = .feed
    private let filmInfo = FilmInfo(title: "Sentimental Value",
                                    posterImageName: "film_page_sentimental_value",
                                    rating: 4.2,
                                    directorLabel: "Directed by",
                                    directorName: "Joachim Trier",
                                    runtimeInfo: "2025 / 135 mins",
                                    synopsis: """
Sisters Nora and Agnes reunite with their estranged father, the charismatic Gustav, a once-renowned director who offers stage actress Nora a role in what he hopes will be his comeback film. When Nora turns it down, she soon discovers he has given her part to an eager young Hollywood star.
""")
    private let carouselItems: [CarouselItem] = [
        .init(imageName: "cart_2"),
        .init(imageName: "cart_1"),
        .init(imageName: "cart_3")
    ]
    private let watchedByItems: [WatchedByItem] = [
        .init(rating: 4),
        .init(rating: 5),
        .init(rating: 3),
        .init(rating: 4),
        .init(rating: 5),
        .init(rating: 4),
        .init(rating: 3),
        .init(rating: 5)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: FilmPageLayout.sectionStackSpacing) {
                header
                filmInfoBlock
                filmCarouselBlock
                actionButtonsBlock
                watchedByBlock
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.top, FilmPageLayout.topInset)
            .padding(.bottom, 120) // leave room for the tab bar overlay
        }
        .background(Color(.systemBackground))
        .overlay(alignment: .bottom) {
            TabBar(selectedTab: $selectedTab)
        }
    }

    private var header: some View {
        HStack {
            Button(action: onClose) {
                CircleGlassButton(systemName: "chevron.left")
            }
            Spacer()
            Button(action: onOpenLink) {
                CircleGlassButton(systemName: "link")
            }
        }
        .padding(.horizontal, FilmPageLayout.horizontalInset)
    }

    private var filmInfoBlock: some View {
        VStack(alignment: .leading, spacing: FilmPageInfoLayout.cardSynopsisSpacing) {
            HStack(alignment: .center, spacing: FilmPageInfoLayout.cardInfoSpacing) {
                FilmInfoCard(item: filmInfo)
                filmInfoTextBlock
            }
            filmInfoSynopsis
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, FilmPageLayout.horizontalInset)
    }

    private var filmInfoTextBlock: some View {
        VStack(alignment: .leading, spacing: FilmPageInfoLayout.titleInfoSpacing) {
            Text(filmInfo.title)
                .typography(Typography.sectionTitle)
                .foregroundStyle(Palette.textPrimary)

            VStack(alignment: .leading, spacing: FilmPageInfoLayout.infoBlockSpacing) {
                directorText
                    .typography(Typography.bodyPrimary)

                Text(filmInfo.runtimeInfo)
                    .typography(Typography.bodyPrimary)
                    .foregroundStyle(Palette.textThird)
            }
        }
    }

    private var filmInfoSynopsis: some View {
        Text(filmInfo.synopsis)
            .typography(Typography.bodyPrimary)
            .lineLimit(4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(
                LinearGradient(
                    colors: [Palette.textSecondary, Palette.textSecondary.opacity(0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }

    private var watchedByBlock: some View {
        VStack(alignment: .leading, spacing: FilmPageInfoLayout.cardSynopsisSpacing) {
            Text("Watched by")
                .typography(Typography.sectionTitle)
                .foregroundStyle(Palette.textPrimary)
                .padding(.horizontal, FilmPageLayout.horizontalInset + FeedLayout.titleHorizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(watchedByItems) { item in
                        WatchedByCard(item: item)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, FilmPageLayout.horizontalInset, for: .scrollContent)
        }
    }

    private var actionButtonsBlock: some View {
        HStack(spacing: 8) {
            PlainCircleButton(systemName: "bookmark")
                .frame(width: 52, height: 52)

            RateActionButton()
                .frame(height: 52)

            PlainCircleButton(systemName: "heart")
                .frame(width: 52, height: 52)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, FilmPageLayout.horizontalInset)
    }

    private var filmCarouselBlock: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: FilmCarouselLayout.cardSpacing) {
                        ForEach(loopedCarouselItems.indices, id: \.self) { index in
                            FilmCarouselCard(item: loopedCarouselItems[index])
                                .id(index)
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view.opacity(phase.isIdentity ? 1.0 : 0.6)
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .contentMargins(
                    .horizontal,
                    (geometry.size.width - FilmCarouselLayout.cardWidth) / 2,
                    for: .scrollContent)
                .onAppear {
                    let centerIndex = loopedCarouselItems.count / 2
                    DispatchQueue.main.async {
                        proxy.scrollTo(centerIndex, anchor: .center)
                    }
                }
            }
        }
        .frame(height: FilmCarouselLayout.cardHeight)
    }

    private var directorText: Text {
        var attributed = AttributedString()
        var label = AttributedString("\(filmInfo.directorLabel) ")
        label.font = Typography.bodyPrimary.font
        label.tracking = Typography.bodyPrimary.tracking
        label.foregroundColor = Palette.textThird
        var name = AttributedString(filmInfo.directorName)
        name.font = Typography.bodyPrimary.font
        name.tracking = Typography.bodyPrimary.tracking
        name.foregroundColor = Palette.textPrimary
        attributed += label
        attributed += name
        return Text(attributed)
    }
}

private struct FilmInfo {
    let title: String
    let posterImageName: String
    let rating: Double
    let directorLabel: String
    let directorName: String
    let runtimeInfo: String
    let synopsis: String
}

private struct CarouselItem: Identifiable {
    let id = UUID()
    let imageName: String
}

private struct WatchedByItem: Identifiable {
    let id = UUID()
    let rating: Int
}

private struct PlainCircleButton: View {
    let systemName: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "FCFCFC"))
                .frame(width: 52, height: 52)
                .overlay(
                    Circle()
                        .strokeBorder(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
                )
            Image(systemName: systemName)
                .font(Typography.tabIcon.font)
                .foregroundStyle(Color.black)
        }
    }
}

private struct RateActionButton: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star")
                .font(Typography.tabIcon.font)
                .foregroundStyle(Color.white)

            Text("Rate, Review + More")
                .typography(Typography.bodyPrimary)
                .foregroundStyle(Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 14)
        .background(Palette.textPrimary)
        .clipShape(Capsule())
    }
}

private struct FilmInfoCard: View {
    let item: FilmInfo

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: FilmPageInfoLayout.cardCornerRadius, style: .continuous)
                .fill(Color.white)
                .frame(width: 96, height: 166)

            VStack(spacing: 0) {
                Image(item.posterImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 96, height: 140)
                    .clipped()

                filmInfoRatingBar
                    .frame(width: 96, height: 26)
            }
            .clipShape(RoundedRectangle(cornerRadius: FilmPageInfoLayout.cardCornerRadius, style: .continuous))
        }
        .overlay(
            RoundedRectangle(cornerRadius: FilmPageInfoLayout.cardCornerRadius, style: .continuous)
                .strokeBorder(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
        )
    }

    private var filmInfoRatingBar: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(Typography.cardTitle.font)
                .foregroundStyle(Palette.textPrimary)

            HStack(spacing: 0) {
                Text(ratingString)
                    .typography(Typography.filmInfoRating)
                    .foregroundStyle(Palette.textPrimary)

                Text(" / 5")
                    .typography(Typography.filmInfoRating)
                    .foregroundStyle(Palette.textThird)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.surface)
        .clipShape(FilmInfoBottomCorners(radius: FilmPageInfoLayout.cardCornerRadius))
        .overlay(
            FilmInfoBottomCorners(radius: FilmPageInfoLayout.cardCornerRadius)
                .strokeBorder(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
        )
    }

    private var ratingString: String {
        String(format: "%.1f", item.rating)
    }
}

struct FilmInfoBottomCorners: InsettableShape {
    let radius: CGFloat
    private var insetAmount: CGFloat = 0

    init(radius: CGFloat) {
        self.radius = radius
    }

    func path(in rect: CGRect) -> Path {
        let adjustedRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let bezier = UIBezierPath(roundedRect: adjustedRect,
                                  byRoundingCorners: [.bottomLeft, .bottomRight],
                                  cornerRadii: CGSize(width: radius, height: radius))
        return Path(bezier.cgPath)
    }

    func inset(by amount: CGFloat) -> FilmInfoBottomCorners {
        var copy = self
        copy.insetAmount += amount
        return copy
    }
}

private extension FilmPage {
    var loopedCarouselItems: [CarouselItem] {
        carouselItems + carouselItems + carouselItems
    }
}

private struct FilmCarouselCard: View {
    let item: CarouselItem

    var body: some View {
        Image(item.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: FilmCarouselLayout.cardWidth, height: FilmCarouselLayout.cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: FilmPageInfoLayout.cardCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: FilmPageInfoLayout.cardCornerRadius, style: .continuous)
                    .strokeBorder(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
            )
            .clipped()
    }
}

private struct WatchedByCard: View {
    let item: WatchedByItem

    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(Palette.surface)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .strokeBorder(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
                )
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Palette.textSecondary)
                )

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(Typography.cardTitle.font)
                    .foregroundStyle(Palette.textPrimary)

                Text("\(item.rating)")
                    .typography(Typography.filmInfoRating)
                    .foregroundStyle(Palette.textPrimary)
            }
            .frame(width: 60, height: 26)
            .background(Palette.surface)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    FilmPage()
}
