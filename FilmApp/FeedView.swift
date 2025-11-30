import SwiftUI
import UIKit

private enum FeedLayout {
    static let sectionSpacing: CGFloat = 8
    static let topContentPadding: CGFloat = 14
    static let titleTopPadding: CGFloat = 4
    static let headingVerticalPadding: CGFloat = 4
    static let titleHorizontalPadding: CGFloat = 4
    static let contentVerticalInset: CGFloat = 4
    static let sectionHorizontalInset: CGFloat = 18
    static let headingIconSpacing: CGFloat = 2
    static let cardTextLeading: CGFloat = 22
    static let cardTextBottom: CGFloat = 10
    static let cardCornerRadius: CGFloat = 12
    static let cardStrokeWidth: CGFloat = 1
    static let cardHeight: CGFloat = 120
    static let posterWidth: CGFloat = 80
    static let posterImageHeight: CGFloat = 120
    static let posterTotalHeight: CGFloat = posterImageHeight + 24
    static let reviewAvatarSize: CGFloat = 18
    static let reviewsCardWidth: CGFloat = 332
}

struct FeedView: View {
    @State private var selectedTab: Tab = .feed
    @State private var selectedSegment: FeedSegment = .all
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
        .init(name: "Ivan", rating: 4, imageName: "in_the_mood_for_love")
    ]
    private let recentStory = RecentStory(title: "With the Stars:",
                                          subtitle: "A Tribute to David Lynch",
                                          authorName: "Karsten",
                                          likes: 29,
                                          avatarImageName: "karsten_avatar",
                                          imageName: "david_lynch_article")
    private let popularItems: [PosterItem] = [
        .init(imageName: "die_my_love"),
        .init(imageName: "if_i_had_legs_id_kick_you"),
        .init(imageName: "nickel_boys"),
        .init(imageName: "sorry_baby"),
        .init(imageName: "the_brutalist"),
        .init(imageName: "urchin")
    ]
    private let switcherGlass = Color(hex: "F5F5F5").opacity(0.1)
    private let perfectDaysStory = RecentStory(title: "", subtitle: "", authorName: "Karsten", likes: 29, avatarImageName: "karsten_avatar", imageName: "perfect_days")
 
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    header
                        .padding(.horizontal, FeedLayout.sectionHorizontalInset)
                    segmentSwitcher
                        .padding(.horizontal, FeedLayout.sectionHorizontalInset)
                    newFromFriends
                    recentStories
                    popularThisWeek
                    reviewsFromFriends
                    // TODO: Subsequent sections (lists/cards) with 36pt spacing
                }
                .padding(.top, FeedLayout.topContentPadding)
                .padding(.bottom, 120) // space for bottom bar overlap4
            }

            BottomNavBar(selectedTab: $selectedTab)
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
                .typography(Typography.pillSegment)
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
            Text("New from friends")
                .typography(Typography.sectionTitle)
                .padding(.top, FeedLayout.titleTopPadding)
                .padding(.horizontal, FeedLayout.titleHorizontalPadding)
                .padding(.horizontal, FeedLayout.sectionHorizontalInset)
                .padding(.bottom, FeedLayout.headingVerticalPadding)

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
            Text("Popular this week")
                .typography(Typography.sectionTitle)
                .padding(.top, FeedLayout.titleTopPadding)
                .padding(.horizontal, FeedLayout.titleHorizontalPadding)
                .padding(.horizontal, FeedLayout.sectionHorizontalInset)
                .padding(.bottom, FeedLayout.headingVerticalPadding)

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

    private var recentStories: some View {
        Button {
            // TODO: Open story detail
        } label: {
            VStack(spacing: FeedLayout.sectionSpacing) {
                HStack(spacing: FeedLayout.headingIconSpacing) {
                    Text("Recent stories")
                        .typography(Typography.sectionTitle)
                        .foregroundStyle(Color.black)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, FeedLayout.titleTopPadding)
                .padding(.horizontal, FeedLayout.titleHorizontalPadding)
                .padding(.bottom, FeedLayout.headingVerticalPadding)

                recentStoryPreviewCard(recentStory)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, FeedLayout.sectionHorizontalInset)
    }

    private var reviewsFromFriends: some View {
        VStack(alignment: .leading, spacing: FeedLayout.sectionSpacing) {
            HStack(spacing: FeedLayout.headingIconSpacing) {
                Text("Reviews from friends")
                    .typography(Typography.sectionTitle)
                    .foregroundStyle(Color.black)
                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, FeedLayout.titleTopPadding)
            .padding(.horizontal, FeedLayout.titleHorizontalPadding)
            .padding(.bottom, FeedLayout.headingVerticalPadding)
            .padding(.horizontal, FeedLayout.sectionHorizontalInset)

            HStack {
                Spacer()
            reviewStoryCard(perfectDaysStory,
                            height: 100,
                            headline: "Perfect Days (2023)",
                            lineLimit: 1)
                    .frame(width: FeedLayout.reviewsCardWidth)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
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
                .font(.system(size: 9, weight: .medium))
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
                .font(.system(size: 17, weight: .regular))
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

private struct RecentStory {
    let title: String
    let subtitle: String
    let authorName: String
    let likes: Int
    let avatarImageName: String
    let imageName: String

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
                    .frame(height: height)
                    .clipShape(TopCorners(radius: FeedLayout.cardCornerRadius))
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
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Palette.textSecondary)
                            Text("\(story.likes)")
                                .typography(Typography.bodyPrimary)
                                .foregroundStyle(Palette.textSecondary)
                        }
                    }

                    Text("Didn’t know a ton about this going into it, especially the similarities to paterson. watching a guy read books, listen to music, and work toilets shouldn’t be this riveting, but it is. and that’s the kind of stuff i can’t get enough of because when you get")
                        .typography(Typography.bodyPrimary)
                        .foregroundStyle(Palette.textSecondary)
                        .lineLimit(3)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                .strokeBorder(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
        )
        .contentShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
    }

    private func recentStoryPreviewCard(_ story: RecentStory,
                                        height: CGFloat = FeedLayout.cardHeight,
                                        headline: String? = nil,
                                        lineLimit: Int = 2) -> some View {
        ZStack(alignment: .bottomLeading) {
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .clipShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
                .clipped()

            Text(headline ?? story.headline)
                .typography(Typography.recentStoryTitle)
                .foregroundStyle(Color.white)
                .lineLimit(lineLimit)
                .padding(.leading, FeedLayout.cardTextLeading)
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
