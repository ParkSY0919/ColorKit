// ColorPalette.swift
// Color palette management

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

/// Represents a color theme with light and dark variants
public struct ColorTheme: Codable {
    public let light: String
    public let dark: String
    
    public init(light: String, dark: String) {
        self.light = light
        self.dark = dark
    }
}

/// Main color palette manager that loads themes from generated data
public final class ColorPalette: @unchecked Sendable {
    public static let shared = ColorPalette()
    
    private let themes: [String: ColorTheme]
    private let loadError: String?
    
    private init() {
        var tempThemes: [String: ColorTheme] = [:]
        var tempError: String? = nil
        
        // Try to load from generated ColorThemes data
        if let data = ColorThemes.data {
            do {
                let decoded = try JSONDecoder().decode([String: ColorTheme].self, from: data)
                tempThemes = decoded
            } catch {
                tempError = "Failed to decode color themes: \(error.localizedDescription)"
            }
        } else {
            tempError = "ColorThemes.data is nil - color generation may not have run"
        }
        
        self.themes = tempThemes
        self.loadError = tempError
        
        if tempThemes.isEmpty {
            print("⚠️ ColorKit: No color themes loaded. \(tempError ?? "Unknown error")")
        } else {
            print("✅ ColorKit: Loaded \(tempThemes.count) color themes")
        }
    }
    
    /// Get theme for a specific color name
    public func theme(for colorName: String) -> ColorTheme? {
        return themes[colorName]
    }
    
    /// Get all available themes
    public var allThemes: [String: ColorTheme] {
        return themes
    }
    
    /// Get count of available colors
    public var colorCount: Int {
        return themes.count
    }
    
    /// Check if the palette is properly loaded
    public var isLoaded: Bool {
        return !themes.isEmpty
    }
    
    /// Get load error if any
    public var error: String? {
        return loadError
    }
    
    /// Validate that ColorKit is properly set up
    public static func validateSetup() {
        let palette = ColorPalette.shared
        
        print("🎨 ColorKit Setup Validation:")
        print("   Colors loaded: \(palette.colorCount)")
        print("   Status: \(palette.isLoaded ? "✅ Ready" : "❌ Failed")")
        
        if let error = palette.error {
            print("   Error: \(error)")
        }
        
        if palette.colorCount > 0 {
            print("   Sample colors:")
            for (name, theme) in Array(palette.allThemes.prefix(3)) {
                print("     - \(name): \(theme.light) / \(theme.dark)")
            }
        }
    }
}
