import SwiftUI

enum Tab: String, CaseIterable {
    case feed
    case watchlist
    case profile

    var title: String {
        switch self {
        case .feed: "Feed"
        case .watchlist: "Watchlist"
        case .profile: "Profile"
        }
    }

    func icon(isActive: Bool) -> String {
        switch self {
        case .feed:
            return "rectangle.stack.fill"
        case .watchlist:
            return "bookmark.fill"
        case .profile:
            return "person.fill"
        }
    }
}

struct BottomNavBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var selectionNamespace
    @Environment(\.displayScale) private var displayScale

    private let barGlass = Color(hex: "D8D8D8").opacity(0.6)

    var body: some View {
        Color.clear
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 8) {
                    tabGroup
                    searchButton
                }
                .padding(.bottom, 0) // ~40px on @3x (iPhone 17)
                .frame(maxWidth: .infinity, alignment: .center) // Center the bar while keeping hugging width
            }
    }

    private var tabGroup: some View {
        HStack(spacing: 4) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(4)
        .frame(height: 60)
        .background(barGlass)
        .liquidGlass(shape: Capsule(), strokeColor: Color.black.opacity(0.1))
        .shadow(color: .black.opacity(0.28), radius: 36, x: 0, y: 8)
    }

    private func tabButton(for tab: Tab) -> some View {
        let isActive = selectedTab == tab
        let iconTextSpacing = 7.0 / displayScale // 7px target, scaled to points

        return Button {
            withAnimation(.snappy) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: iconTextSpacing) {
                Image(systemName: tab.icon(isActive: isActive))
                    .font(.system(size: tab == .profile ? 20 : 17,
                                  weight: .medium))
                    .frame(width: 20, height: 20) // Uniform frame keeps text aligned across tabs
                Text(tab.title)
                    .font(.system(size: 10, weight: .medium)) // Matches provided spec (SF Pro, Medium, 10pt)
            }
            .frame(width: isActive ? 82 : 62, height: 52)
            .foregroundStyle(isActive ? Color.white : Color.black)
            .background(
                ZStack {
                    if isActive {
                        Capsule()
                            .fill(Color.black)
                            .matchedGeometryEffect(id: "tabBackground", in: selectionNamespace)
                            .overlay(
                        Capsule()
                            .strokeBorder(Palette.divider, lineWidth: 1)
                            )
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }

    private var searchButton: some View {
        Button {
            // Hook up search action here.
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 21, weight: .regular)) // SF Pro Regular, 21pt
                .frame(width: 21, height: 21)
                .foregroundStyle(Color.black)
                .frame(width: 60, height: 60)
                .background(barGlass)
                .liquidGlass(shape: Capsule(), strokeColor: Color.black.opacity(0.1))
        }
        .shadow(color: .black.opacity(0.28), radius: 36, x: 0, y: 8)
        .buttonStyle(.plain)
    }
}

#Preview {
    StatefulPreviewWrapper(Tab.feed) { selection in
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<40) { idx in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 80)
                        .overlay(Text("Row \(idx)").foregroundStyle(.primary))
                        .padding(.horizontal)
                }
            }
            .padding(.top, 32)
        }
        .background(Color(.systemBackground))
        .overlay(alignment: .bottom) {
            BottomNavBar(selectedTab: selection)
        }
    }
}

/// Simple stateful wrapper to supply bindings in previews.
struct StatefulPreviewWrapper<Value: Equatable, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
