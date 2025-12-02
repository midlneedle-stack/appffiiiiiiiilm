import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .feed

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                FeedView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                ZStack {
                    VariableBlurView(maxBlurRadius: 2, direction: .blurredBottomClearTop)
                        .frame(height: 148)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(.systemBackground).opacity(0.0), location: 0),
                                    .init(color: Color(.systemBackground).opacity(0.3), location: 0.5),
                                    .init(color: Color(.systemBackground).opacity(1.0), location: 1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 148)
                }
                .allowsHitTesting(false)

                TabBar(selectedTab: $selectedTab)
                    .zIndex(1)
                    .padding(.bottom, proxy.safeAreaInsets.bottom)
            }
            .ignoresSafeArea(edges: .bottom)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(.systemBackground).opacity(0.9), location: 0),
                                .init(color: Color(.systemBackground).opacity(0.8), location: 0.32),
                                .init(color: Color(.systemBackground).opacity(0.6), location: 0.62),
                                .init(color: Color(.systemBackground).opacity(0.0), location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: proxy.safeAreaInsets.top)
                    .ignoresSafeArea(edges: .top)
            }
        }
    }
}

#Preview {
    ContentView()
}
