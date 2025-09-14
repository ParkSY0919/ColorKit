// ColorKit.swift
// Main ColorKit interface

import Foundation

/// ColorKit - Design Token Color Management
/// 
/// ColorKit automatically generates Swift color enums from Figma design tokens,
/// providing seamless light/dark mode support without manual Asset Catalog management.
public enum ColorKit {
    
    /// Validate that ColorKit is properly set up with color data
    /// Call this during app startup to ensure colors are loaded
    public static func validateSetup() {
        ColorPalette.validateSetup()
    }
    
    /// Get theme for a specific color by name
    public static func theme(for colorName: String) -> ColorTheme? {
        return ColorPalette.shared.theme(for: colorName)
    }
    
    /// Get theme for a Colors enum case
    public static func theme(for color: Colors) -> ColorTheme? {
        return ColorPalette.shared.theme(for: color.rawValue)
    }
    
    /// Get all available color themes
    public static var allThemes: [String: ColorTheme] {
        return ColorPalette.shared.allThemes
    }
    
    /// Get count of loaded colors
    public static var colorCount: Int {
        return ColorPalette.shared.colorCount
    }
    
    /// Check if ColorKit is properly loaded
    public static var isReady: Bool {
        return ColorPalette.shared.isLoaded
    }
    
    /// Get setup error if any
    public static var setupError: String? {
        return ColorPalette.shared.error
    }
}
