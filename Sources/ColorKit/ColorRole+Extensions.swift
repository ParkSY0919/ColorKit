// ColorRole+Extensions.swift
// Extensions for ColorRole to provide SwiftUI and UIKit colors

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(AppKit)
import AppKit
#endif

// MARK: - UIColor Extensions

#if canImport(UIKit)
extension UIColor {
    /// Create UIColor from hex string
    public convenience init?(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var value: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&value) else { return nil }
        
        let hasAlpha = cleaned.count == 8
        let a = hasAlpha ? CGFloat((value & 0xFF000000) >> 24) / 255 : 1
        let r = CGFloat((value & 0xFF0000) >> 16) / 255
        let g = CGFloat((value & 0x00FF00) >> 8) / 255
        let b = CGFloat( value & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
#endif

// MARK: - SwiftUI Color Extensions

#if canImport(SwiftUI)
@available(iOS 14.0, macOS 11.0, *)
extension Color {
    /// Create SwiftUI Color from hex string
    public init?(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var value: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&value) else { return nil }
        
        let hasAlpha = cleaned.count == 8
        let a = hasAlpha ? Double((value & 0xFF000000) >> 24) / 255 : 1
        let r = Double((value & 0xFF0000) >> 16) / 255
        let g = Double((value & 0x00FF00) >> 8) / 255
        let b = Double( value & 0x0000FF) / 255
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    /// Create Color with light and dark variants
    public init(light: Color, dark: Color) {
        #if canImport(UIKit)
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

// MARK: - ColorRole Extensions for UI Colors

extension ColorRole {
    
    /// Get the ColorTheme for this role
    public var theme: ColorTheme? {
        return ColorKit.theme(for: self)
    }
    
    #if canImport(UIKit)
    /// Get UIColor that automatically adapts to light/dark mode
    public var uiColor: UIColor {
        guard let theme = self.theme else {
            print("⚠️ ColorKit: No theme found for role '\(self.rawValue)'. Using fallback color.")
            return UIColor.systemGray
        }
        
        return UIColor { traitCollection in
            let colorString = traitCollection.userInterfaceStyle == .dark ? theme.dark : theme.light
            return UIColor(hex: colorString) ?? UIColor.systemGray
        }
    }
    #endif
    
    #if canImport(SwiftUI)
    /// Get SwiftUI Color that automatically adapts to light/dark mode
    public var color: Color {
        guard let theme = self.theme else {
            print("⚠️ ColorKit: No theme found for role '\(self.rawValue)'. Using fallback color.")
            return Color.gray
        }
        
        let lightColor = Color(hex: theme.light) ?? Color.gray
        let darkColor = Color(hex: theme.dark) ?? Color.gray
        
        #if canImport(UIKit)
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(darkColor) : UIColor(lightColor)
        })
        #else
        // macOS without UIKit - use light color as fallback
        return lightColor
        #endif
    }
    #endif
}

// MARK: - Convenience Color Access

/// Convenient access to standard color roles
public struct AppColors {
    
    // Background colors
    public static let primary = ColorRole.primary
    public static let secondary = ColorRole.secondary
    public static let tertiary = ColorRole.tertiary
    public static let surface = ColorRole.surface
    public static let elevated = ColorRole.elevated
    
    // Text colors
    public static let textPrimary = ColorRole.textPrimary
    public static let textSecondary = ColorRole.textSecondary
    public static let textTertiary = ColorRole.textTertiary
    public static let textOnPrimary = ColorRole.textOnPrimary
    
    // Brand colors
    public static let brandPrimary = ColorRole.brandPrimary
    public static let brandSecondary = ColorRole.brandSecondary
    public static let brandAccent = ColorRole.brandAccent
    public static let brandSubtle = ColorRole.brandSubtle
    
    // Status colors
    public static let success = ColorRole.success
    public static let warning = ColorRole.warning
    public static let error = ColorRole.error
    public static let info = ColorRole.info
    
    // Border colors
    public static let borderLight = ColorRole.borderLight
    public static let borderMedium = ColorRole.borderMedium
    public static let borderStrong = ColorRole.borderStrong
    public static let borderAccent = ColorRole.borderAccent
}