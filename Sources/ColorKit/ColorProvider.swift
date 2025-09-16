// ColorProvider.swift
// Protocol-based color providing system

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

/// Protocol for providing colors from various sources
public protocol ColorProvider {
    /// Load colors from the provider's source
    func loadColors() throws
    
    /// Get a color theme for a specific role
    func colorTheme(for role: ColorRole) -> ColorTheme?
    
    /// Get all available color themes mapped by role
    var allColorThemes: [ColorRole: ColorTheme] { get }
    
    /// Check if the provider is ready to provide colors
    var isReady: Bool { get }
    
    /// Get any loading error
    var error: String? { get }
}

/// JSON-based color provider that loads colors from JSON files in the app bundle
public class JSONColorProvider: ColorProvider {
    private var colorThemes: [ColorRole: ColorTheme] = [:]
    private var loadError: String?
    private let mappingSet: ColorMappingSet
    private let jsonFileName: String
    
    /// Initialize with a mapping set and JSON file name
    /// - Parameters:
    ///   - mappingSet: The mapping configuration that connects JSON color names to ColorRole
    ///   - jsonFileName: The name of the JSON file (without extension) to load from the app bundle
    public init(mappingSet: ColorMappingSet, jsonFileName: String = "app-colors") {
        self.mappingSet = mappingSet
        self.jsonFileName = jsonFileName
    }
    
    public func loadColors() throws {
        colorThemes.removeAll()
        loadError = nil
        
        guard let bundle = Bundle.main.path(forResource: jsonFileName, ofType: "json") else {
            let error = "JSON file '\(jsonFileName).json' not found in app bundle"
            loadError = error
            throw ColorProviderError.fileNotFound(error)
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: bundle))
            let jsonColors = try JSONDecoder().decode([String: ColorTheme].self, from: data)
            
            // Map JSON colors to standard roles using the mapping set
            for role in mappingSet.configuredRoles {
                guard let jsonColorName = mappingSet.jsonColorName(for: role),
                      let colorTheme = jsonColors[jsonColorName] else {
                    print("⚠️ ColorKit: No mapping found for role '\(role.rawValue)' -> '\(mappingSet.jsonColorName(for: role) ?? "nil")'")
                    continue
                }
                
                colorThemes[role] = colorTheme
            }
            
            print("✅ ColorKit: Successfully loaded \(colorThemes.count) colors from '\(jsonFileName).json'")
            
        } catch {
            let errorMessage = "Failed to load or decode JSON: \(error.localizedDescription)"
            loadError = errorMessage
            throw ColorProviderError.loadingFailed(errorMessage)
        }
    }
    
    public func colorTheme(for role: ColorRole) -> ColorTheme? {
        return colorThemes[role]
    }
    
    public var allColorThemes: [ColorRole: ColorTheme] {
        return colorThemes
    }
    
    public var isReady: Bool {
        return !colorThemes.isEmpty && loadError == nil
    }
    
    public var error: String? {
        return loadError
    }
}

/// Errors that can occur during color loading
public enum ColorProviderError: Error, LocalizedError {
    case fileNotFound(String)
    case loadingFailed(String)
    case mappingError(String)
    
    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let message):
            return "File not found: \(message)"
        case .loadingFailed(let message):
            return "Loading failed: \(message)"
        case .mappingError(let message):
            return "Mapping error: \(message)"
        }
    }
}
