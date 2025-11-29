import SwiftUI

extension Color {
    /// Hex initializer for 6-char RGB (e.g., "F5F5F5"). Alpha assumed 1.
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xff) / 255
        let g = Double((int >> 08) & 0xff) / 255
        let b = Double((int >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b)
    }
}
