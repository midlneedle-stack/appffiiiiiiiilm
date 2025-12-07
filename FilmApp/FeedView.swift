import SwiftUI
import UIKit

private enum FeedLayout {
    static let sectionSpacing: CGFloat = 10 // Vertical gap between each major block.
    static let sectionStackSpacing: CGFloat = 28 // Stack spacing for header+content groups.
    static let topContentPadding: CGFloat = 18 // Safe-area top inset for the scroll content.
    static let titleHorizontalPadding: CGFloat = 4 // Extra +4pt applied to section titles (18 + 4 = 22pt visual).
    static let sectionHorizontalInset: CGFloat = 18 // Core 18pt horizontal gutter used throughout scroll content.
    static let headingIconSpacing: CGFloat = 2 // Gap between headings and the trailing chevron icon.
    static let headingSubtitleSpacing: CGFloat = 4 // Gap between title and subtitle when present.
    static let headingContentSpacing: CGFloat = 14 // Gap between the title block (with subtitle) and its content when subtitle is on.
    static let cardTextLeading: CGFloat = 16 // Leading inset for story title text overlays.
    static let cardTextBottom: CGFloat = 14 // Bottom inset for story title text overlays above cards.
    static let cardCornerRadius: CGFloat = 12 // Corner radius applied to cards and rounded backgrounds.
    static let cardStrokeWidth: CGFloat = 1 // Border stroke width for card outlines.
    static let cardHeight: CGFloat = 120 // Standard height for review and story preview cards.
    static let posterWidth: CGFloat = 80 // Width of poster cards used in horizontal lists.
    static let posterImageHeight: CGFloat = 120 // Height of poster imagery inside friend/popular/list cards.
    static let posterTotalHeight: CGFloat = posterImageHeight + 24 // Total friend card height (image + label area).
    static let reviewAvatarSize: CGFloat = 18 // Diameter for review avatar thumbnails.
    static let listMiniPosterWidth: CGFloat = 40 // Width of mini posters inside list cards.
    static let listMiniPosterHeight: CGFloat = 60 // Height of mini posters inside list cards.
}

struct FeedView: View {
    @State private var selectedSegment: FeedSegment = .all
    @State private var reviewsSectionWidth: CGFloat? = nil
    private let newFromFriendsItems: [FriendItem] = [
        .init(name: "Egor", rating: 4, imageName: "challengers"),
        .init(name: "Yana", rating: 5, imageName: "saturday_night"),
        .init(name: "Petar", rating: 5, imageName: "i_like_movies"),
        .init(name: "Nick", rating: 4, imageName: "the_master"),
        .init(name: "David", rating: 4, imageName: "train-dreams"),
        .init(name: "Alex...", rating: 5, imageName: "sentimental-value"),
        .init(name: "Clay", rating: 4, imageName: "columbus"),
        .init(name: "Sonya", rating: 4, imageName: "marriage_story"),
        .init(name: "Lana", rating: 5, imageName: "blow_up"),
        .init(name: "Noah", rating: 5, imageName: "perfect_blue"),
        .init(name: "Ivan", rating: 4, imageName: "in_the_mood_for_love"),
        .init(name: "Mara", rating: 5, imageName: "arrival"),
        .init(name: "Jonah", rating: 4, imageName: "adaptation"),
        .init(name: "Sasha", rating: 5, imageName: "palo_alto"),
        .init(name: "Ruth", rating: 5, imageName: "hedgehog_in_the_fog"),
        .init(name: "Vera", rating: 4, imageName: "arze"),
        .init(name: "Sam", rating: 5, imageName: "dead_mans_wire"),
        .init(name: "Lena", rating: 4, imageName: "a_house_of_dynamite"),
        .init(name: "Marco", rating: 5, imageName: "a_travelers_needs"),
        .init(name: "Tina", rating: 4, imageName: "bunnylovr"),
        .init(name: "Eli", rating: 5, imageName: "eddington"),
        .init(name: "Milo", rating: 4, imageName: "it_was_just_an_accident"),
        .init(name: "Pia", rating: 5, imageName: "look_back"),
        .init(name: "Dima", rating: 4, imageName: "peter"),
        .init(name: "Zora", rating: 5, imageName: "ping_pong_the_animation"),
        .init(name: "Leo", rating: 4, imageName: "the_baltimorons")
    ]
    private let recentStory = RecentStory(title: "With the Stars:",
                                          subtitle: "A Tribute to David Lynch",
                                          authorName: "Karsten",
                                          likes: 29,
                                          rating: 4,
                                          avatarImageName: "karsten_avatar",
                                          imageName: "david_lynch_article",
                                          body: "An intimate portrait of two artists trying to share a moment before the credits roll.")
    private let popularItems: [PosterItem] = [
        .init(imageName: "die_my_love"),
        .init(imageName: "marty_supreme"),
        .init(imageName: "sound_of_falling"),
        .init(imageName: "jay_kelly"),
        .init(imageName: "hamnet"),
        .init(imageName: "the_mastermind"),
        .init(imageName: "the_smashing_machine"),
        .init(imageName: "sirat"),
        .init(imageName: "happyend"),
        .init(imageName: "if_i_had_legs_id_kick_you"),
        .init(imageName: "no_other_choice"),
        .init(imageName: "one_battle_after_another"),
        .init(imageName: "sorry_baby"),
        .init(imageName: "the_brutalist"),
    ]
    private let switcherGlass = Color(hex: "F5F5F5").opacity(0.1)
    private let reviewStories: [RecentStory] = [
        .init(title: "",
              subtitle: "Her (2013)",
              authorName: "Karsten",
              likes: 29,
              rating: 5,
              avatarImageName: "karsssten",
              imageName: "her",
              body: """
              without getting too personal, this film just helped me a lot. when you’re happy this thing can really put you down. but when you’re down it takes a big warm blanket and wraps it around you.
              """),
        .init(title: "",
              subtitle: "Frances Ha (2012)",
              authorName: "Masha",
              likes: 18,
              rating: 4,
              avatarImageName: "masha",
              imageName: "frances_ha",
              body: """
              i somehow grow to love benji even more each time i watch this, and crave the kind of relationship he has with frances. the sharing of new music, and movie nights, and leaving the door ajar so frances can call out in the night if she needs him. the way they created their own language in how they look at each other, which still exists even after not seeing each other for quite some time. it’s such a sweet, simple bond built around small gestures and providing care... benji has a special kind of magic about him.
              """),
        .init(title: "",
              subtitle: "Courier (1986)",
              authorName: "Clay",
              likes: 12,
              rating: 4,
              avatarImageName: "clay",
              imageName: "courier",
              body: """
              Catcher in the Rye, but URSS. I loved it. I think its about kids who grew up to fast, who are not ready to be adults, but they try to play until the society forces the childhood out of them. A great sense of loneliness and need for freedom.
              """),
        .init(title: "",
              subtitle: "Christmas Again (2023)",
              authorName: "Ivan",
              likes: 23,
              rating: 5,
              avatarImageName: "karsten_avatar",
              imageName: "christmas_again",
              body: """
              I just adore this imperfect mumblecore shot on 16mm by the one and only Sean Price Williams. Christmas, Again is a type of movie that makes you get under a blanket and drink hot chocolate while listening to Christmas songs by Sufjan Stevens and Phoebe Bridgers whose songs are filled with melancholy and loneliness of this time of year, so it’s pretty much perfect for me.
              """)
    ]
    private let listItems: [ListItem] = [
        .init(title: "Criterion Frame Works", posterImageNames: [
            "criterion_frames",
            "criterion_haine",
            "criterion_lion",
            "criterion_yi"
        ]),
        .init(title: "Horror Poetry", posterImageNames: [
            "horrors_cure",
            "horrors_lamb",
            "horrors_rosemary",
            "horrors_thin"
        ]),
        .init(title: "Indie Signal Flares", posterImageNames: [
            "indie_aftersun",
            "indie_hal_harpert",
            "indie_rap_world",
            "indie_sweet"
        ]),
        .init(title: "Japanese Soundtracks", posterImageNames: [
            "japan_dmc",
            "japan_klko",
            "japan_kukijiro",
            "japan_oasis"
        ]),
        .init(title: "Lost in Your 20s", posterImageNames: [
            "lost20s_courier",
            "lost20s_king",
            "lost20s_summer",
            "lost20s_worst"
        ]),
        .init(title: "Drive & Revolutions", posterImageNames: [
            "car_bullit",
            "car_drive",
            "car_french",
            "car_night"
        ])
    ]
    private let cannesFilms: [CannesFilm] = [
        .init(title: "Embers of the Sky", imageName: "Screenshot 2025-12-07 at 14.42.11"),
        .init(title: "Quiet Tide", imageName: "Screenshot 2025-12-07 at 14.42.34"),
        .init(title: "Silver Horizon", imageName: "Screenshot 2025-12-07 at 14.42.53"),
        .init(title: "Midnight Promenade", imageName: nil),
        .init(title: "Paper Lanterns", imageName: nil),
        .init(title: "Northbound Lights", imageName: nil)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: FeedLayout.sectionStackSpacing) {
                header
                    .padding(.horizontal, FeedLayout.sectionHorizontalInset)
                segmentSwitcher
                    .padding(.horizontal, FeedLayout.sectionHorizontalInset)
                newFromFriends
                recentStories
                popularThisWeek
                reviewsFromFriends
                listsSection
                cannesSection
                // TODO: Subsequent sections (lists/cards) should share sectionStackSpacing
            }
            .padding(.top, FeedLayout.topContentPadding)
            .padding(.bottom, 120)
        }
        .background(Color.white)
    }

    private var header: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                CircleGlassButton(systemName: "bell")
                Spacer()
                Text("Letterboxd")
                    .typography(Typography.titleNav)
                Spacer()
                CircleGlassButton(systemName: "gearshape")
            }
        }
    }

    private var segmentSwitcher: some View {
        HStack(spacing: 0) {
            segmentButton(.all)
            segmentButton(.friends)
        }
        .frame(height: 40)
        .padding(4)
        .background(switcherGlass)
        .liquidGlass(shape: Capsule(), strokeColor: Color.black.opacity(0.1))
    }

    private func segmentButton(_ segment: FeedSegment) -> some View {
        let isActive = segment == selectedSegment
        return Button {
            withAnimation(.snappy) {
                selectedSegment = segment
            }
        } label: {
                Text(segment.title)
                    .typography(Typography.bodySecondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .foregroundStyle(isActive ? Color.black : Palette.textThird)
        }
        .buttonStyle(.plain)
        .background(
            Capsule()
                .fill(isActive ? Color.white : Color.clear)
            .overlay(
                Capsule()
                    .strokeBorder(isActive ? Palette.divider : Color.clear, lineWidth: 1)
            )
        )
    }

    private var newFromFriends: some View {
        VStack(alignment: .leading, spacing: FeedLayout.sectionSpacing) {
            sectionHeading("New from friends")

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 10) {
                    ForEach(newFromFriendsItems) { item in
                        FriendCard(item: item)
                    }
                }
            }
            .contentMargins(.horizontal, FeedLayout.sectionHorizontalInset, for: .scrollContent)
        }
    }

    private var popularThisWeek: some View {
        VStack(alignment: .leading, spacing: FeedLayout.sectionSpacing) {
            sectionHeading("Popular this week")

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 10) {
                    ForEach(popularItems) { item in
                        PosterCard(item: item)
                    }
                }
            }
            .contentMargins(.horizontal, FeedLayout.sectionHorizontalInset, for: .scrollContent)
        }
    }

    private var cannesSection: some View {
        VStack(alignment: .leading, spacing: FeedLayout.headingContentSpacing) {
            sectionHeading("Cannes 2026",
                           showAccessory: false,
                           subtitle: "Take a closer look at the 79th Festival de Cannes")

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 6) {
                    ForEach(cannesFilms) { film in
                        CannesPosterCard(item: film)
                    }
                }
            }
            .contentMargins(.horizontal, FeedLayout.sectionHorizontalInset, for: .scrollContent)
        }
    }

    private var listsSection: some View {
        VStack(alignment: .leading, spacing: FeedLayout.sectionSpacing) {
            sectionHeading("Lists", showAccessory: true)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 10) {
                    ForEach(listItems) { item in
                        ListCard(item: item)
                    }
                }
            }
            .contentMargins(.horizontal, FeedLayout.sectionHorizontalInset, for: .scrollContent)
        }
    }

    private var recentStories: some View {
        Button {
            // TODO: Open story detail
        } label: {
            VStack(spacing: FeedLayout.sectionSpacing) {
                sectionHeading("Recent stories", showAccessory: true)

                recentStoryPreviewCard(recentStory)
                    .padding(.horizontal, FeedLayout.sectionHorizontalInset)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var reviewsFromFriends: some View {
        VStack(alignment: .leading, spacing: FeedLayout.sectionSpacing) {
            sectionHeading("Reviews from friends", showAccessory: true)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(reviewStories) { story in
                        reviewStoryCard(story, height: FeedLayout.cardHeight)
                            .frame(width: computedReviewsCardWidth)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, FeedLayout.sectionHorizontalInset, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            reviewsSectionWidth = proxy.size.width
                        }
                        .onChange(of: proxy.size.width) { _, newValue in
                            reviewsSectionWidth = newValue
                        }
                }
            )
        }
    }

    @ViewBuilder
    private func sectionHeading(_ title: String,
                                showAccessory: Bool = false,
                                subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: subtitle == nil ? 0 : FeedLayout.headingSubtitleSpacing) {
            HStack(alignment: .lastTextBaseline, spacing: FeedLayout.headingIconSpacing) {
                Text(title)
                    .typography(Typography.sectionTitle)
                    .foregroundStyle(Color.black)
                    .padding(.leading, FeedLayout.sectionHorizontalInset + FeedLayout.titleHorizontalPadding)
                if showAccessory {
                    Image(systemName: "chevron.right")
                        .font(Typography.sectionAccessoryIcon.font)
                        .foregroundStyle(Color.black)
                        .alignmentGuide(.lastTextBaseline) { dimensions in
                            dimensions[.bottom]
                        }
                }
            }

            if let subtitle {
                Text(subtitle)
                    .typography(Typography.bodyPrimary)
                    .foregroundStyle(Palette.textThird)
                    .padding(.leading, FeedLayout.sectionHorizontalInset + FeedLayout.titleHorizontalPadding)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct FriendItem: Identifiable {
    let id = UUID()
    let name: String
    let rating: Int
    let imageName: String
}

private struct FriendCard: View {
    let item: FriendItem

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                .fill(Color.white)
                .frame(width: FeedLayout.posterWidth, height: FeedLayout.posterTotalHeight)
            VStack(spacing: 0) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: FeedLayout.posterWidth, height: FeedLayout.posterImageHeight)
                    .clipShape(TopCorners(radius: FeedLayout.cardCornerRadius))
                    .clipped()
                bottomBar
                    .frame(width: FeedLayout.posterWidth, height: FeedLayout.posterTotalHeight - FeedLayout.posterImageHeight)
                    .clipShape(BottomCorners(radius: FeedLayout.cardCornerRadius))
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                .strokeBorder(Palette.divider, lineWidth: 1)
        )
    }

    private var bottomBar: some View {
            HStack(spacing: 4) {
                Text(item.name)
                    .typography(Typography.cardTitle)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(Palette.textSecondary)
            Capsule()
                .fill(Palette.divider)
                .frame(width: 1, height: 12)
            Image(systemName: "star.fill")
                .font(Typography.ratingStarIcon.font)
                .foregroundStyle(Palette.textSecondary)
            Text("\(item.rating)")
                .typography(Typography.cardTitle)
                .foregroundStyle(Palette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: 24)
        .background(Color.surface)
    }
}

private struct TopCorners: Shape {
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let bezier = UIBezierPath(roundedRect: rect,
                                  byRoundingCorners: [.topLeft, .topRight],
                                  cornerRadii: CGSize(width: radius, height: radius))
        return Path(bezier.cgPath)
    }
}

private extension FeedView {
    var computedReviewsCardWidth: CGFloat {
        guard let baseWidth = reviewsSectionWidth else { return 0 }
        return max(0, baseWidth - (FeedLayout.sectionHorizontalInset * 2))
    }
}

private struct BottomCorners: Shape {
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let bezier = UIBezierPath(roundedRect: rect,
                                  byRoundingCorners: [.bottomLeft, .bottomRight],
                                  cornerRadii: CGSize(width: radius, height: radius))
        return Path(bezier.cgPath)
    }
}

private struct CircleGlassButton: View {
    let systemName: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "F5F5F5").opacity(0.1))
                .frame(width: 44, height: 44)
                .liquidGlass(shape: Circle(), strokeColor: Color.black.opacity(0.1))
            Image(systemName: systemName)
                .font(Typography.tabIcon.font)
                .foregroundStyle(Color.black)
        }
    }
}

private struct PosterItem: Identifiable {
    let id = UUID()
    let imageName: String
}

private struct PosterCard: View {
    let item: PosterItem

    var body: some View {
        Image(item.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: FeedLayout.posterWidth, height: FeedLayout.posterImageHeight)
            .clipShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                    .strokeBorder(Palette.divider, lineWidth: 1)
            )
            .clipped()
    }
}

private struct ListItem: Identifiable {
    let id = UUID()
    let title: String
    let posterImageNames: [String]
}

private struct CannesFilm: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String?
}

private struct ListCard: View {
    let item: ListItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                    .fill(Color.surface)
                grid
            }
            .frame(width: FeedLayout.posterWidth, height: FeedLayout.posterImageHeight)
            .clipShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                    .strokeBorder(Palette.divider, lineWidth: 1)
            )

            Text(item.title)
                .typography(Typography.bodyPrimary)
                .foregroundStyle(Palette.textPrimary)
                .frame(width: FeedLayout.posterWidth, alignment: .leading)
                .lineLimit(2)
        }
    }

    private var grid: some View {
        VStack(spacing: 0) {
            row(indices: 0..<2)
            row(indices: 2..<4)
        }
    }

    @ViewBuilder
    private func row(indices: Range<Int>) -> some View {
        HStack(spacing: 0) {
            ForEach(indices, id: \.self) { index in
                miniPoster(at: index)
            }
        }
    }

    @ViewBuilder
    private func miniPoster(at index: Int) -> some View {
        if let name = posterName(at: index) {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: FeedLayout.listMiniPosterWidth, height: FeedLayout.listMiniPosterHeight, alignment: .center)
                .clipped()
        } else {
            Color.surface
                .frame(width: FeedLayout.listMiniPosterWidth, height: FeedLayout.listMiniPosterHeight)
        }
    }

    private func posterName(at index: Int) -> String? {
        guard item.posterImageNames.indices.contains(index) else { return nil }
        return item.posterImageNames[index]
    }
}

private struct RecentStory: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let authorName: String
    let likes: Int
    let rating: Int
    let avatarImageName: String
    let imageName: String
    let body: String

    var headline: String {
        "\(title)\n\(subtitle)"
    }
}

private extension FeedView {
    func reviewStoryCard(_ story: RecentStory,
                         height: CGFloat = FeedLayout.cardHeight,
                         headline: String? = nil,
                         lineLimit: Int = 2) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Image(story.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: height, alignment: .top)
                    .clipShape(TopCorners(radius: FeedLayout.cardCornerRadius))
                    .overlay(
                        TopCorners(radius: FeedLayout.cardCornerRadius)
                            .stroke(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
                    )
                    .clipped()

                Text(headline ?? story.headline)
                    .typography(Typography.recentStoryTitle)
                    .foregroundStyle(Color.white)
                    .lineLimit(lineLimit)
                    .padding(.leading, FeedLayout.cardTextLeading)
                    .padding(.bottom, FeedLayout.cardTextBottom)
            }

            storyFooterPanel {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Image(story.avatarImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: FeedLayout.reviewAvatarSize, height: FeedLayout.reviewAvatarSize)
                            .clipShape(Circle())

                        Text(story.authorName)
                            .typography(Typography.storyHeadline)
                            .foregroundStyle(Palette.textPrimary)

                        Spacer()

                        HStack(spacing: 2) {
                        Image(systemName: "heart.fill")
                            .font(Typography.badgeIcon.font)
                            .foregroundStyle(Palette.textSecondary)
                            Text("\(story.likes)")
                                .typography(Typography.bodyPrimary)
                                .foregroundStyle(Palette.textSecondary)
                        }
                    }

                HStack(spacing: 0) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < story.rating ? "star.fill" : "star")
                    .font(Typography.cardTitle.font)
                            .foregroundStyle(Palette.textPrimary)
                    }
                }

                Text(story.body)
                    .typography(Typography.bodyPrimary)
                    .foregroundStyle(Palette.textSecondary)
                    .lineLimit(3)

            }
        }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .clipShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
    }

    private func recentStoryPreviewCard(_ story: RecentStory,
                                        height: CGFloat = FeedLayout.cardHeight,
                                        headline: String? = nil,
                                        lineLimit: Int = 2) -> some View {
        ZStack(alignment: .bottomLeading) {
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .overlay(alignment: .center) {
                    Image(story.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: height)
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))

            Text(headline ?? story.headline)
                .typography(Typography.recentStoryTitle)
                .foregroundStyle(Color.white)
                .lineLimit(lineLimit)
                .padding(.leading, FeedLayout.cardTextLeading)
                .padding(.trailing, FeedLayout.cardTextLeading)
                .padding(.bottom, FeedLayout.cardTextBottom)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                .strokeBorder(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
        )
        .contentShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
    }

    private func storyFooterPanel<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
        .padding(.bottom, 22)
        .padding(.horizontal, FeedLayout.cardTextLeading)
        .background(Color.surface)
        .clipShape(BottomCorners(radius: FeedLayout.cardCornerRadius))
        .overlay(
            BottomCorners(radius: FeedLayout.cardCornerRadius)
                .stroke(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
        )
    }
}

enum FeedSegment: String {
    case all
    case friends

    var title: String {
        switch self {
        case .all: "All"
        case .friends: "Friends"
        }
    }
}

private struct CannesPosterCard: View {
    let item: CannesFilm

    var body: some View {
        ZStack {
            if let imageName = item.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 270)
                    .clipped()
            } else {
                Color.surface
            }
        }
        .frame(width: 180, height: 270)
        .clipShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                .strokeBorder(Palette.divider, lineWidth: 1)
        )
    }
}
