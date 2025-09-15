// Color+Extensions.swift
// SwiftUI extensions

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, macOS 11.0, *)
extension Colors {
    /// SwiftUI에서 사용할 수 있는 Color
    /// 자동으로 Light/Dark 모드를 지원합니다
    public var color: Color {
        #if canImport(UIKit)
        return Color(uiColor)
        #else
        // macOS 등에서 UIKit이 없는 경우
        guard let theme = ColorPalette.shared.theme(for: rawValue) else {
            assertionFailure("⚠️ ColorKit: Color '\(rawValue)' not found")
            return .pink
        }
        
        return Color(
            light: Color(hex: theme.light),
            dark: Color(hex: theme.dark)
        )
        #endif
    }
}

@available(iOS 14.0, macOS 11.0, *)
extension Color {
    public init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        
        let hasAlpha = cleaned.count == 8
        let a = hasAlpha ? Double((value & 0xFF000000) >> 24) / 255 : 1
        let r = Double((value & 0xFF0000) >> 16) / 255
        let g = Double((value & 0x00FF00) >> 8) / 255
        let b = Double( value & 0x0000FF) / 255
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    public init(light: Color, dark: Color) {
        #if canImport(UIKit)
        // iOS 14.0+에서 더 효율적인 방법 사용
        self.init(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        // For macOS without UIKit, use basic color (no dynamic switching)
        self = light
        #endif
    }
}
#endif
