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
    static let cardWidth: CGFloat = 268 // Width of each carousel card.
    static let cardHeight: CGFloat = 152 // Height of each carousel card.
    static let cardSpacing: CGFloat = 6 // Horizontal spacing between carousel cards.
}

struct FilmPage: View {
    var onClose: () -> Void = {}
    var onOpenLink: () -> Void = {}
    @State private var selectedTab: Tab = .feed
    @State private var carouselIndex: Int = 0
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

    var body: some View {
        VStack(spacing: FilmPageLayout.sectionStackSpacing) {
            header
            filmInfoBlock
            filmCarouselBlock
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, FilmPageLayout.topInset)
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

    private var filmCarouselBlock: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FilmCarouselLayout.cardSpacing) {
                    ForEach(loopedCarouselItems.indices, id: \.self) { index in
                        let item = loopedCarouselItems[index]

                        FilmCarouselCard(item: item)
                            .id(index)
                            .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                view.opacity(phase.isIdentity ? 1.0 : 0.6)
                            }
                    }
                }
                .padding(.horizontal, FilmPageLayout.horizontalInset)
            }
            .onAppear {
                let centerIndex = carouselItems.count + 1 // Middle item of the middle triplet (cart_1)
                carouselIndex = centerIndex
                proxy.scrollTo(centerIndex, anchor: .center)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        snapCarousel(using: value, proxy: proxy)
                    }
            )
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

    func snapCarousel(using value: DragGesture.Value, proxy: ScrollViewProxy) {
        let translation = value.translation.width
        let velocity = value.predictedEndTranslation.width - translation

        let direction: Int
        if abs(velocity) > 20 {
            direction = velocity < 0 ? 1 : -1
        } else {
            direction = translation < 0 ? 1 : -1
        }

        let baseCount = carouselItems.count
        guard baseCount > 0 else { return }
        var targetIndex = carouselIndex + direction

        if targetIndex < baseCount {
            targetIndex += baseCount
        } else if targetIndex >= baseCount * 2 {
            targetIndex -= baseCount
        }

        carouselIndex = targetIndex
        withAnimation(.easeOut(duration: 0.25)) {
            proxy.scrollTo(targetIndex, anchor: .center)
        }
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

#Preview {
    FilmPage()
}
