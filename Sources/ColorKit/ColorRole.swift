// ColorRole.swift
// Standard color roles for ColorKit

import Foundation

/// Standard color roles that define semantic color usage in an application
/// These roles provide consistent naming across different design systems
public enum ColorRole: String, CaseIterable {
    // Background colors
    case primary = "primary"
    case secondary = "secondary" 
    case tertiary = "tertiary"
    case surface = "surface"
    case elevated = "elevated"
    
    // Text colors
    case textPrimary = "textPrimary"
    case textSecondary = "textSecondary"
    case textTertiary = "textTertiary"
    case textOnPrimary = "textOnPrimary"
    
    // Brand colors
    case brandPrimary = "brandPrimary"
    case brandSecondary = "brandSecondary"
    case brandAccent = "brandAccent"
    case brandSubtle = "brandSubtle"
    
    // Status colors
    case success = "success"
    case warning = "warning"
    case error = "error"
    case info = "info"
    
    // Border colors
    case borderLight = "borderLight"
    case borderMedium = "borderMedium"
    case borderStrong = "borderStrong"
    case borderAccent = "borderAccent"
    
    /// Human-readable description of the color role
    public var description: String {
        switch self {
        case .primary: return "Primary Background"
        case .secondary: return "Secondary Background"
        case .tertiary: return "Tertiary Background"
        case .surface: return "Surface Background"
        case .elevated: return "Elevated Background"
        case .textPrimary: return "Primary Text"
        case .textSecondary: return "Secondary Text"
        case .textTertiary: return "Tertiary Text"
        case .textOnPrimary: return "Text on Primary"
        case .brandPrimary: return "Primary Brand"
        case .brandSecondary: return "Secondary Brand"
        case .brandAccent: return "Brand Accent"
        case .brandSubtle: return "Subtle Brand"
        case .success: return "Success"
        case .warning: return "Warning"
        case .error: return "Error"
        case .info: return "Info"
        case .borderLight: return "Light Border"
        case .borderMedium: return "Medium Border"
        case .borderStrong: return "Strong Border"
        case .borderAccent: return "Accent Border"
        }
    }
    
    /// Category grouping for the color role
    public var category: String {
        switch self {
        case .primary, .secondary, .tertiary, .surface, .elevated:
            return "Background"
        case .textPrimary, .textSecondary, .textTertiary, .textOnPrimary:
            return "Text"
        case .brandPrimary, .brandSecondary, .brandAccent, .brandSubtle:
            return "Brand"
        case .success, .warning, .error, .info:
            return "Status"
        case .borderLight, .borderMedium, .borderStrong, .borderAccent:
            return "Border"
        }
    }
}

/// Mapping configuration that connects JSON color names to standard ColorRole
public struct ColorMapping {
    /// The name of the color in the JSON file
    public let jsonColorName: String
    
    /// The standard role this color should map to
    public let role: ColorRole
    
    public init(jsonColorName: String, role: ColorRole) {
        self.jsonColorName = jsonColorName
        self.role = role
    }
}

/// Collection of ColorMapping configurations
public struct ColorMappingSet {
    private let mappings: [ColorRole: String]
    
    public init(_ mappings: [ColorMapping]) {
        var dict: [ColorRole: String] = [:]
        for mapping in mappings {
            dict[mapping.role] = mapping.jsonColorName
        }
        self.mappings = dict
    }
    
    /// Get the JSON color name for a given role
    public func jsonColorName(for role: ColorRole) -> String? {
        return mappings[role]
    }
    
    /// Get all configured roles
    public var configuredRoles: [ColorRole] {
        return Array(mappings.keys)
    }
    
    /// Get all mappings as a dictionary
    public var allMappings: [ColorRole: String] {
        return mappings
    }
}