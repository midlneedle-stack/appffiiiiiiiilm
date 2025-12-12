import SwiftUI

private enum FilmPageLayout {
    static let horizontalInset: CGFloat = FeedLayout.sectionHorizontalInset
    static let topInset: CGFloat = 18
    static let sectionStackSpacing: CGFloat = FeedLayout.sectionStackSpacing
}

private enum FilmPageInfoLayout {
    static let cardInfoSpacing: CGFloat = 18
    static let titleInfoSpacing: CGFloat = 10
    static let infoBlockSpacing: CGFloat = 4
}

struct FilmPage: View {
    var onClose: () -> Void = {}
    var onOpenLink: () -> Void = {}
    private let filmInfo = FilmInfo(title: "Sentimental Value",
                                    posterImageName: "film_page_sentimental_value",
                                    rating: 4.2,
                                    directorLabel: "Directed by",
                                    directorName: "Joachim Trier",
                                    runtimeInfo: "2025 / 135 mins")

    var body: some View {
        VStack(spacing: FilmPageLayout.sectionStackSpacing) {
            header
            filmInfoBlock
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, FilmPageLayout.topInset)
        .background(Color(.systemBackground))
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
        HStack(alignment: .center, spacing: FilmPageInfoLayout.cardInfoSpacing) {
            FilmInfoCard(item: filmInfo)
            filmInfoTextBlock
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
}

private struct FilmInfoCard: View {
    let item: FilmInfo

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                .fill(Color.white)
                .frame(width: 95, height: 168)

            VStack(spacing: 0) {
                Image(item.posterImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 95, height: 140)
                    .clipped()

                filmInfoRatingBar
                    .frame(width: 95, height: 28)
            }
            .clipShape(RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous))
        }
        .overlay(
            RoundedRectangle(cornerRadius: FeedLayout.cardCornerRadius, style: .continuous)
                .strokeBorder(Palette.divider, lineWidth: FeedLayout.cardStrokeWidth)
        )
    }

    private var filmInfoRatingBar: some View {
        HStack(spacing: 2) {
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
    }

    private var ratingString: String {
        String(format: "%.1f", item.rating)
    }
}

#Preview {
    FilmPage()
}
