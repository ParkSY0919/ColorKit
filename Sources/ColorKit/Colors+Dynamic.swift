// Colors+Dynamic.swift
// Dynamic color access system with multiple access patterns

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

/// Dynamic color access system that provides multiple ways to access colors
@dynamicMemberLookup
public struct Colors {
    
    // MARK: - Static Access Methods
    
    /// Get color theme by exact JSON key name
    /// - Parameter jsonKey: The exact key from JSON (e.g., "AppBackground.main")
    /// - Returns: ColorTheme if found
    public static func colorTheme(for jsonKey: String) -> ColorTheme? {
        return ColorKit.shared.dynamicProvider?.colorTheme(forKey: jsonKey)
    }
    
    /// Get color theme by property name
    /// - Parameter propertyName: Swift property name (e.g., "appBackgroundMain")
    /// - Returns: ColorTheme if found
    public static func colorTheme(forProperty propertyName: String) -> ColorTheme? {
        return ColorKit.shared.dynamicProvider?.colorTheme(forProperty: propertyName)
    }
    
    /// String-based color access - supports both JSON keys and property names
    /// - Parameter colorName: Color name (JSON key or property name)
    /// - Returns: ColorTheme if found
    public static func color(named colorName: String) -> ColorTheme? {
        // Try JSON key first, then property name
        if let theme = colorTheme(for: colorName) {
            return theme
        }
        return colorTheme(forProperty: colorName)
    }
    
    // MARK: - Subscript Access
    
    /// Subscript access for color themes
    /// - Parameter colorName: Color name (supports both JSON keys and property names)
    /// - Returns: ColorTheme if found
    public static subscript(colorName: String) -> ColorTheme? {
        return color(named: colorName)
    }
    
    // MARK: - Dynamic Member Lookup
    
    /// Dynamic member lookup for property-style access
    /// - Parameter member: Property name
    /// - Returns: DynamicColorProperty for further access
    public static subscript(dynamicMember member: String) -> DynamicColorProperty {
        return DynamicColorProperty(propertyName: member)
    }
    
    // MARK: - SwiftUI Color Extensions
    
    #if canImport(SwiftUI)
    /// Get SwiftUI Color by name with automatic light/dark adaptation
    /// - Parameter colorName: Color name (JSON key or property name)
    /// - Returns: SwiftUI Color with fallback to gray if not found
    @available(iOS 14.0, macOS 11.0, *)
    public static func swiftUIColor(named colorName: String) -> Color {
        guard let theme = color(named: colorName) else {
            print("⚠️ ColorKit: Color '\(colorName)' not found. Using fallback.")
            return Color.gray
        }
        
        return theme.swiftUIColor
    }
    #endif
    
    // MARK: - UIKit Color Extensions
    
    #if canImport(UIKit)
    /// Get UIColor by name with automatic light/dark adaptation
    /// - Parameter colorName: Color name (JSON key or property name)
    /// - Returns: UIColor with fallback to gray if not found
    public static func uiColor(named colorName: String) -> UIColor {
        guard let theme = color(named: colorName) else {
            print("⚠️ ColorKit: Color '\(colorName)' not found. Using fallback.")
            return UIColor.systemGray
        }
        
        return theme.uiColor
    }
    #endif
    
    // MARK: - Discovery and Introspection
    
    /// Get all available color names (JSON keys)
    public static var allColorNames: [String] {
        return ColorKit.shared.dynamicProvider?.allColorNames ?? []
    }
    
    /// Get all available property names
    public static var allPropertyNames: [String] {
        return ColorKit.shared.dynamicProvider?.allPropertyNames ?? []
    }
    
    /// Get colors organized by category
    public static var colorsByCategory: [String: [String: ColorTheme]] {
        return ColorKit.shared.dynamicProvider?.colorsByCategory ?? [:]
    }
    
    /// Search colors by partial name match
    /// - Parameter searchTerm: Term to search for
    /// - Returns: Array of matching color names
    public static func searchColors(containing searchTerm: String) -> [String] {
        let lowercasedTerm = searchTerm.lowercased()
        return allColorNames.filter { colorName in
            colorName.lowercased().contains(lowercasedTerm)
        }
    }
}

/// Helper struct for dynamic property access
public struct DynamicColorProperty {
    private let propertyName: String
    
    init(propertyName: String) {
        self.propertyName = propertyName
    }
    
    /// Get the ColorTheme for this property
    public var theme: ColorTheme? {
        return Colors.colorTheme(forProperty: propertyName)
    }
    
    #if canImport(SwiftUI)
    /// Get SwiftUI Color for this property
    @available(iOS 14.0, macOS 11.0, *)
    public var color: Color {
        guard let theme = self.theme else {
            print("⚠️ ColorKit: Color '\(propertyName)' not found. Using fallback.")
            return Color.gray
        }
        
        return theme.swiftUIColor
    }
    #endif
    
    #if canImport(UIKit)
    /// Get UIColor for this property
    public var uiColor: UIColor {
        return Colors.uiColor(named: propertyName)
    }
    #endif
    
    /// Check if this color exists
    public var exists: Bool {
        return theme != nil
    }
}

// MARK: - ColorTheme Extensions for UI

extension ColorTheme {
    
    #if canImport(SwiftUI)
    /// Get SwiftUI Color with automatic light/dark switching
    @available(iOS 14.0, macOS 11.0, *)
    public var swiftUIColor: Color {
        guard let lightColor = Color(hex: light),
              let darkColor = Color(hex: dark) else {
            print("⚠️ ColorKit: Invalid hex colors in theme. Light: \(light), Dark: \(dark)")
            return Color.gray
        }
        
        // iOS에서 UIColor 기반 동적 색상이 가장 안정적
        #if canImport(UIKit)
        let dynamicUIColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(darkColor)
            case .light, .unspecified:
                return UIColor(lightColor)
            @unknown default:
                return UIColor(lightColor)
            }
        }
        return Color(dynamicUIColor)
        #else
        // macOS 또는 다른 플랫폼에서는 기본 색상 사용
        return lightColor
        #endif
    }
    #endif
    
    #if canImport(UIKit)
    /// Get UIColor with automatic light/dark switching
    public var uiColor: UIColor {
        return UIColor { traitCollection in
            let colorString = traitCollection.userInterfaceStyle == .dark ? dark : light
            return UIColor(hex: colorString) ?? UIColor.systemGray
        }
    }
    #endif
}

// MARK: - Convenience Extensions

/// Namespace for commonly used color patterns
public extension Colors {
    
    /// Common background colors (if they exist)
    struct Background {
        public static var main: DynamicColorProperty { Colors.appBackgroundMain }
        public static var card: DynamicColorProperty { Colors.appBackgroundCard }
        public static var elevated: DynamicColorProperty { Colors.appBackgroundElevated }
    }
    
    /// Common text colors (if they exist)
    struct Text {
        public static var heading: DynamicColorProperty { Colors.appTextHeading }
        public static var body: DynamicColorProperty { Colors.appTextBody }
        public static var caption: DynamicColorProperty { Colors.appTextCaption }
        public static var onPrimary: DynamicColorProperty { Colors.appTextOnPrimary }
    }
    
    /// Common brand colors (if they exist)
    struct Brand {
        public static var main: DynamicColorProperty { Colors.appBrandMain }
        public static var accent: DynamicColorProperty { Colors.appBrandAccent }
        public static var subtle: DynamicColorProperty { Colors.appBrandSubtle }
    }
    
    /// Common state colors (if they exist)
    struct State {
        public static var success: DynamicColorProperty { Colors.appStateSuccess }
        public static var warning: DynamicColorProperty { Colors.appStateWarning }
        public static var danger: DynamicColorProperty { Colors.appStateDanger }
        public static var info: DynamicColorProperty { Colors.appStateInfo }
    }
    
    /// Common border colors (if they exist)
    struct Border {
        public static var light: DynamicColorProperty { Colors.appBorderLight }
        public static var medium: DynamicColorProperty { Colors.appBorderMedium }
        public static var accent: DynamicColorProperty { Colors.appBorderAccent }
    }
}

// MARK: - Runtime Color Extensions Generation

/// Helper to generate color extensions at runtime
public class RuntimeColorExtensions {
    
    /// Generate Swift code for static extensions based on discovered colors
    /// This can be used for build-time code generation if needed
    /// - Parameter discoveryResult: Result from color discovery
    /// - Returns: Swift code as string
    public static func generateExtensionCode(from discoveryResult: ColorDiscoveryResult) -> String {
        var code = """
// Auto-generated color extensions
// DO NOT EDIT - This file is generated automatically

extension Colors {

"""
        
        // Generate individual color properties
        for (propertyName, jsonKey) in discoveryResult.propertyMappings {
            code += """
    /// Color: \(jsonKey)
    public static var \(propertyName): DynamicColorProperty {
        return DynamicColorProperty(propertyName: "\(propertyName)")
    }
    
"""
        }
        
        code += "}\n"
        
        return code
    }
}