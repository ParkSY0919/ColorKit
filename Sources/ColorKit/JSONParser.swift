// JSONParser.swift
// Flexible JSON parsing for dynamic color discovery

import Foundation

/// Enhanced JSON parser that automatically discovers colors regardless of JSON structure
public class FlexibleJSONParser {
    
    /// Parse JSON and discover all color definitions with automatic structure detection
    /// - Parameter data: JSON data to parse
    /// - Returns: Dictionary of color name to ColorTheme
    /// - Throws: Parsing errors
    public static func parseColors(from data: Data) throws -> [String: ColorTheme] {
        // First, try to parse as JSON object
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw FlexibleParserError.invalidJSONStructure("Root level must be a JSON object")
        }
        
        var discoveredColors: [String: ColorTheme] = [:]
        
        // Recursively discover colors in the JSON structure
        try discoverColors(in: jsonObject, currentPath: "", colors: &discoveredColors)
        
        return discoveredColors
    }
    
    /// Parse JSON for single theme (light or dark only)
    /// - Parameter data: JSON data to parse
    /// - Returns: Dictionary of color name to hex string
    /// - Throws: Parsing errors
    public static func parseColorsForSingleTheme(from data: Data) throws -> [String: String] {
        // First, try to parse as JSON object
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw FlexibleParserError.invalidJSONStructure("Root level must be a JSON object")
        }
        
        var discoveredColors: [String: String] = [:]
        
        // Recursively discover colors in the JSON structure
        try discoverSingleThemeColors(in: jsonObject, currentPath: "", colors: &discoveredColors)
        
        return discoveredColors
    }
    
    /// Recursively traverse JSON structure to find color definitions
    private static func discoverColors(
        in object: [String: Any], 
        currentPath: String, 
        colors: inout [String: ColorTheme]
    ) throws {
        
        for (key, value) in object {
            let fullPath = currentPath.isEmpty ? key : "\(currentPath).\(key)"
            
            if let colorDict = value as? [String: Any] {
                // Check if this is a color theme object (has light/dark keys)
                if let lightValue = colorDict["light"], let darkValue = colorDict["dark"] {
                    // This is a color theme
                    let lightHex = extractColorValue(from: lightValue)
                    let darkHex = extractColorValue(from: darkValue)
                    
                    if let light = lightHex, let dark = darkHex {
                        colors[fullPath] = ColorTheme(light: light, dark: dark)
                    }
                } else {
                    // This might be a nested structure, recurse into it
                    try discoverColors(in: colorDict, currentPath: fullPath, colors: &colors)
                }
            } else if let colorValue = extractColorValue(from: value) {
                // This might be a single color value (no light/dark variants)
                // Create a theme with the same color for both light and dark
                colors[fullPath] = ColorTheme(light: colorValue, dark: colorValue)
            }
        }
    }
    
    /// Extract color value from various possible formats
    private static func extractColorValue(from value: Any) -> String? {
        if let stringValue = value as? String {
            // Check if it's a hex color
            if isValidHexColor(stringValue) {
                return stringValue
            }
        }
        
        // Could add support for other formats like rgb, rgba, etc.
        return nil
    }
    
    /// Recursively traverse JSON structure to find single theme colors
    private static func discoverSingleThemeColors(
        in object: [String: Any], 
        currentPath: String, 
        colors: inout [String: String]
    ) throws {
        
        for (key, value) in object {
            let fullPath = currentPath.isEmpty ? key : "\(currentPath).\(key)"
            
            if let colorDict = value as? [String: Any] {
                // This might be a nested structure, recurse into it
                try discoverSingleThemeColors(in: colorDict, currentPath: fullPath, colors: &colors)
            } else if let colorValue = extractColorValue(from: value) {
                // This is a single color value
                colors[fullPath] = colorValue
            }
        }
    }
    
    /// Validate if a string is a valid hex color
    private static func isValidHexColor(_ hex: String) -> Bool {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // Check if it's 6 or 8 character hex
        guard cleaned.count == 6 || cleaned.count == 8 else { return false }
        
        // Check if all characters are valid hex
        return cleaned.allSatisfy { char in
            char.isHexDigit
        }
    }
}

/// Enhanced color discovery that creates sanitized property names
public class DynamicColorDiscovery {
    
    /// Generate Swift-safe property names from JSON color keys
    /// - Parameter jsonKey: Original JSON key (e.g., "AppBackground.main")
    /// - Returns: Swift-safe property name (e.g., "appBackgroundMain")
    public static func swiftPropertyName(from jsonKey: String) -> String {
        // Split by dots and handle each part
        let parts = jsonKey.components(separatedBy: ".")
        
        var result = ""
        for (index, part) in parts.enumerated() {
            let cleanPart = part
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: "_", with: "")
                .replacingOccurrences(of: " ", with: "")
            
            if index == 0 {
                // First part should be lowercase
                result += cleanPart.lowercased()
            } else {
                // Subsequent parts should be capitalized
                result += cleanPart.capitalized
            }
        }
        
        // Ensure it starts with a letter
        if !result.isEmpty && result.first?.isLetter != true {
            result = "color" + result.capitalized
        }
        
        return result.isEmpty ? "unknownColor" : result
    }
    
    /// Generate category-based grouping from JSON keys
    /// - Parameter jsonKey: Original JSON key
    /// - Returns: Category name (e.g., "AppBackground" -> "background")
    public static func categoryName(from jsonKey: String) -> String {
        let parts = jsonKey.components(separatedBy: ".")
        guard let firstPart = parts.first else { return "general" }
        
        // Extract category from names like "AppBackground", "AppText", etc.
        let cleaned = firstPart
            .replacingOccurrences(of: "App", with: "")
            .lowercased()
        
        return cleaned.isEmpty ? "general" : cleaned
    }
    
    /// Create a comprehensive color discovery result
    /// - Parameter colors: Discovered colors from JSON
    /// - Returns: Organized color discovery result
    public static func organizeColors(_ colors: [String: ColorTheme]) -> ColorDiscoveryResult {
        var byCategory: [String: [String: ColorTheme]] = [:]
        var propertyMappings: [String: String] = [:]
        
        for (jsonKey, theme) in colors {
            let category = categoryName(from: jsonKey)
            let propertyName = swiftPropertyName(from: jsonKey)
            
            if byCategory[category] == nil {
                byCategory[category] = [:]
            }
            byCategory[category]?[propertyName] = theme
            propertyMappings[propertyName] = jsonKey
        }
        
        return ColorDiscoveryResult(
            allColors: colors,
            categorizedColors: byCategory,
            propertyMappings: propertyMappings
        )
    }
}

/// Result of color discovery process
public struct ColorDiscoveryResult {
    /// All discovered colors keyed by their original JSON names
    public let allColors: [String: ColorTheme]
    
    /// Colors organized by category
    public let categorizedColors: [String: [String: ColorTheme]]
    
    /// Mapping from Swift property names to original JSON keys
    public let propertyMappings: [String: String]
    
    /// Get all available categories
    public var categories: [String] {
        return Array(categorizedColors.keys).sorted()
    }
    
    /// Get color count
    public var totalColorCount: Int {
        return allColors.count
    }
}

/// Errors that can occur during flexible parsing
public enum FlexibleParserError: Error, LocalizedError {
    case invalidJSONStructure(String)
    case noColorsFound
    case parsingFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidJSONStructure(let message):
            return "Invalid JSON structure: \(message)"
        case .noColorsFound:
            return "No valid colors found in JSON"
        case .parsingFailed(let message):
            return "Parsing failed: \(message)"
        }
    }
}

/// Extension to Character for hex validation
private extension Character {
    var isHexDigit: Bool {
        return isNumber || ("a"..."f").contains(lowercased()) || ("A"..."F").contains(self)
    }
}