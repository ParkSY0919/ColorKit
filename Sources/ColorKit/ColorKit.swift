// ColorKit.swift
// Main ColorKit interface

import Foundation

/// ColorKit - Design Token Color Management
/// 
/// ColorKit provides flexible color management that supports different JSON color naming schemes
/// through configurable mappings to standard semantic color roles.
public final class ColorKit {
    public static let shared = ColorKit()
    
    private var colorProvider: ColorProvider?
    
    private init() {}
    
    /// Configure ColorKit with a color provider and mapping set
    /// Call this during app startup to set up color loading
    /// - Parameters:
    ///   - mappingSet: Configuration that maps JSON color names to standard ColorRole
    ///   - jsonFileName: Name of the JSON file (without extension) in the app bundle
    public static func configure(with mappingSet: ColorMappingSet, jsonFileName: String = "app-colors") {
        let provider = JSONColorProvider(mappingSet: mappingSet, jsonFileName: jsonFileName)
        shared.colorProvider = provider
        
        do {
            try provider.loadColors()
        } catch {
            print("❌ ColorKit: Failed to load colors - \(error.localizedDescription)")
        }
    }
    
    /// Configure ColorKit with a custom color provider
    /// - Parameter provider: Custom color provider implementation
    public static func configure(with provider: ColorProvider) {
        shared.colorProvider = provider
        
        do {
            try provider.loadColors()
        } catch {
            print("❌ ColorKit: Failed to load colors - \(error.localizedDescription)")
        }
    }
    
    /// Validate that ColorKit is properly set up with color data
    /// Call this to check setup status and get diagnostic information
    public static func validateSetup() {
        print("🎨 ColorKit Setup Validation:")
        
        guard let provider = shared.colorProvider else {
            print("   Status: ❌ Not configured - call ColorKit.configure() first")
            return
        }
        
        print("   Colors loaded: \(provider.allColorThemes.count)")
        print("   Status: \(provider.isReady ? "✅ Ready" : "❌ Failed")")
        
        if let error = provider.error {
            print("   Error: \(error)")
        }
        
        if provider.isReady {
            print("   Sample colors:")
            for (role, theme) in Array(provider.allColorThemes.prefix(3)) {
                print("     - \(role.rawValue): \(theme.light) / \(theme.dark)")
            }
        }
    }
    
    /// Get theme for a specific color role
    public static func theme(for role: ColorRole) -> ColorTheme? {
        return shared.colorProvider?.colorTheme(for: role)
    }
    
    /// Get all available color themes mapped by role
    public static var allThemes: [ColorRole: ColorTheme] {
        return shared.colorProvider?.allColorThemes ?? [:]
    }
    
    /// Get count of loaded colors
    public static var colorCount: Int {
        return shared.colorProvider?.allColorThemes.count ?? 0
    }
    
    /// Check if ColorKit is properly loaded
    public static var isReady: Bool {
        return shared.colorProvider?.isReady ?? false
    }
    
    /// Get setup error if any
    public static var setupError: String? {
        return shared.colorProvider?.error
    }
}
