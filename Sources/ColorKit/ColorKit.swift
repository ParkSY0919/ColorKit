// ColorKit.swift
// Main ColorKit interface with both legacy and dynamic color support

import Foundation

/// ColorKit - Design Token Color Management
/// 
/// ColorKit provides flexible color management that supports different JSON color naming schemes
/// through configurable mappings to standard semantic color roles.
public final class ColorKit {
    public static let shared = ColorKit()

    private var colorProvider: ColorProvider?
    internal var dynamicProvider: DynamicColorProvider?

    // MARK: - Debug Settings

    /// Enable/disable missing color warnings (default: true)
    public static var enableMissingColorWarnings: Bool = true

    /// Enable/disable access logging for debugging (default: false)
    public static var enableAccessLogging: Bool = false

    /// Set of color names that were requested but not found
    private static var _missingColors: Set<String> = []

    /// Get all requested but missing color names
    public static var requestedMissingColors: [String] {
        return Array(_missingColors).sorted()
    }

    /// Record a missing color (called internally)
    internal static func recordMissingColor(_ name: String) {
        _missingColors.insert(name)
        if enableMissingColorWarnings {
            print("⚠️ ColorKit: Color '\(name)' not found. Using fallback.")
        }
    }

    /// Record color access (called internally)
    internal static func logAccess(_ name: String, found: Bool) {
        if enableAccessLogging {
            let status = found ? "✓" : "✗"
            print("🔍 ColorKit: [\(status)] Accessed '\(name)'")
        }
    }

    /// Clear the missing colors record
    public static func clearMissingColors() {
        _missingColors.removeAll()
    }

    private init() {}
    
    /// Configure ColorKit with simplified setup - just provide JSON file name
    /// This automatically discovers all colors without requiring mapping configuration
    /// - Parameter jsonFileName: Name of the JSON file (without extension) in the app bundle
    public static func configure(jsonFileName: String = "app-colors") {
        let dynamicProvider = DynamicColorProvider(jsonFileName: jsonFileName)
        shared.dynamicProvider = dynamicProvider
        
        do {
            try dynamicProvider.loadColors()
            print("✅ ColorKit: Auto-discovered \(dynamicProvider.colorCount) colors from '\(dynamicProvider.loadedFileNames.joined(separator: ", "))'")
        } catch {
            print("❌ ColorKit: Failed to load colors - \(error.localizedDescription)")
        }
    }
    
    /// Configure ColorKit with a color provider and mapping set (legacy support)
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
        
        // Check dynamic provider first (new system)
        if let dynamicProvider = shared.dynamicProvider {
            print("   Mode: Dynamic (auto-discovery)")
            print("   Colors loaded: \(dynamicProvider.colorCount)")
            print("   Status: \(dynamicProvider.isReady ? "✅ Ready" : "❌ Failed")")
            
            if let error = dynamicProvider.error {
                print("   Error: \(error)")
            }
            
            if dynamicProvider.isReady {
                print("   Categories: \(dynamicProvider.discoveryResult?.categories.joined(separator: ", ") ?? "none")")
                print("   Sample colors:")
                for (name, theme) in Array(dynamicProvider.allColors.prefix(3)) {
                    print("     - \(name): \(theme.light) / \(theme.dark)")
                }
            }
            return
        }
        
        // Fall back to legacy provider
        guard let provider = shared.colorProvider else {
            print("   Status: ❌ Not configured - call ColorKit.configure() first")
            return
        }
        
        print("   Mode: Legacy (mapping-based)")
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
        if let dynamicProvider = shared.dynamicProvider {
            return dynamicProvider.isReady
        }
        return shared.colorProvider?.isReady ?? false
    }
    
    /// Get setup error if any
    public static var setupError: String? {
        if let dynamicProvider = shared.dynamicProvider {
            return dynamicProvider.error
        }
        return shared.colorProvider?.error
    }
    
    /// Get total color count
    public static var totalColorCount: Int {
        if let dynamicProvider = shared.dynamicProvider {
            return dynamicProvider.colorCount
        }
        return shared.colorProvider?.allColorThemes.count ?? 0
    }
    
    /// Print all missing colors that were requested but not found
    public static func printMissingColors() {
        let missing = requestedMissingColors
        if missing.isEmpty {
            print("✅ ColorKit: No missing colors recorded.")
        } else {
            print("⚠️ ColorKit: \(missing.count) missing color(s):")
            for name in missing {
                print("   - \(name)")
            }
        }
    }

    /// Print all available colors for debugging
    public static func printAllColors() {
        print("🎨 All Available Colors:")
        
        if let dynamicProvider = shared.dynamicProvider {
            print("   Dynamic Mode - \(dynamicProvider.colorCount) colors found:")
            for (name, theme) in dynamicProvider.allColors.sorted(by: { $0.key < $1.key }) {
                print("     \(name): \(theme.light) → \(theme.dark)")
            }
            
            if let result = dynamicProvider.discoveryResult {
                print("\n   Property Names:")
                for (propName, jsonKey) in result.propertyMappings.sorted(by: { $0.key < $1.key }) {
                    print("     .\(propName) → \"\(jsonKey)\"")
                }
            }
        } else if let provider = shared.colorProvider {
            print("   Legacy Mode - \(provider.allColorThemes.count) colors found:")
            for (role, theme) in provider.allColorThemes.sorted(by: { $0.key.rawValue < $1.key.rawValue }) {
                print("     \(role.rawValue): \(theme.light) → \(theme.dark)")
            }
        } else {
            print("   ❌ No colors loaded - call ColorKit.configure() first")
        }
    }
}

// MARK: - Dynamic Color Provider

/// Provider that automatically discovers colors from JSON without requiring mappings
internal class DynamicColorProvider {
    private let jsonFileName: String
    private(set) var allColors: [String: ColorTheme] = [:]
    private(set) var discoveryResult: ColorDiscoveryResult?
    private(set) var loadError: String?
    private(set) var loadedFileNames: [String] = []
    
    init(jsonFileName: String) {
        self.jsonFileName = jsonFileName
    }
    
    func loadColors() throws {
        allColors.removeAll()
        discoveryResult = nil
        loadError = nil
        loadedFileNames.removeAll()
        
        // Check for light and dark mode JSON files first
        let lightFileName = "\(jsonFileName)-light"
        let darkFileName = "\(jsonFileName)-dark"
        
        let lightPath = Bundle.main.path(forResource: lightFileName, ofType: "json")
        let darkPath = Bundle.main.path(forResource: darkFileName, ofType: "json")
        
        if let lightPath = lightPath, let darkPath = darkPath {
            // Both light and dark files exist - load theme-based colors
            try loadThemeBasedColors(lightPath: lightPath, darkPath: darkPath)
            loadedFileNames = ["\(lightFileName).json", "\(darkFileName).json"]
        } else {
            // Fall back to single file mode
            guard let singlePath = Bundle.main.path(forResource: jsonFileName, ofType: "json") else {
                let error = "JSON file '\(jsonFileName).json' not found in app bundle"
                loadError = error
                throw ColorProviderError.fileNotFound(error)
            }
            
            try loadSingleFileColors(path: singlePath)
            loadedFileNames = ["\(jsonFileName).json"]
        }
    }
    
    private func loadThemeBasedColors(lightPath: String, darkPath: String) throws {
        do {
            let lightData = try Data(contentsOf: URL(fileURLWithPath: lightPath))
            let darkData = try Data(contentsOf: URL(fileURLWithPath: darkPath))
            
            let lightColors = try FlexibleJSONParser.parseColorsForSingleTheme(from: lightData)
            let darkColors = try FlexibleJSONParser.parseColorsForSingleTheme(from: darkData)
            
            // Combine light and dark colors into ColorThemes
            var combinedColors: [String: ColorTheme] = [:]
            
            // Get all unique color keys from both files
            let allKeys = Set(lightColors.keys).union(Set(darkColors.keys))
            
            for key in allKeys {
                let lightValue = lightColors[key] ?? "#000000"  // Default fallback
                let darkValue = darkColors[key] ?? lightValue   // Use light as fallback for dark
                
                combinedColors[key] = ColorTheme(light: lightValue, dark: darkValue)
            }
            
            guard !combinedColors.isEmpty else {
                let error = "No valid colors found in light/dark JSON files"
                loadError = error
                throw FlexibleParserError.noColorsFound
            }
            
            allColors = combinedColors
            discoveryResult = DynamicColorDiscovery.organizeColors(combinedColors)
            
        } catch {
            let errorMessage = "Failed to load or parse light/dark JSON files: \(error.localizedDescription)"
            loadError = errorMessage
            throw ColorProviderError.loadingFailed(errorMessage)
        }
    }
    
    private func loadSingleFileColors(path: String) throws {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let discoveredColors = try FlexibleJSONParser.parseColors(from: data)
            
            guard !discoveredColors.isEmpty else {
                let error = "No valid colors found in JSON file"
                loadError = error
                throw FlexibleParserError.noColorsFound
            }
            
            allColors = discoveredColors
            discoveryResult = DynamicColorDiscovery.organizeColors(discoveredColors)
            
        } catch {
            let errorMessage = "Failed to load or parse JSON: \(error.localizedDescription)"
            loadError = errorMessage
            throw ColorProviderError.loadingFailed(errorMessage)
        }
    }
    
    func colorTheme(forKey jsonKey: String) -> ColorTheme? {
        return allColors[jsonKey]
    }
    
    func colorTheme(forProperty propertyName: String) -> ColorTheme? {
        guard let result = discoveryResult,
              let jsonKey = result.propertyMappings[propertyName] else {
            return nil
        }
        return allColors[jsonKey]
    }
    
    var allColorNames: [String] {
        return Array(allColors.keys).sorted()
    }
    
    var allPropertyNames: [String] {
        guard let result = discoveryResult else { return [] }
        return Array(result.propertyMappings.keys).sorted()
    }
    
    var colorsByCategory: [String: [String: ColorTheme]] {
        return discoveryResult?.categorizedColors ?? [:]
    }
    
    var isReady: Bool {
        return !allColors.isEmpty && loadError == nil
    }
    
    var error: String? {
        return loadError
    }
    
    var colorCount: Int {
        return allColors.count
    }
}
