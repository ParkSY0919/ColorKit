// Colors+Generated.swift
// Runtime-generated color extensions for discovered colors

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Generated Color Extensions

/// This extension provides compile-time accessible properties for colors discovered in JSON.
/// These properties are generated based on the JSON structure and naming conventions.
extension Colors {
    
    // MARK: - AppBackground Colors
    
    /// AppBackground.main
    public static var appBackgroundMain: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appBackgroundMain")
    }
    
    /// AppBackground.card
    public static var appBackgroundCard: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appBackgroundCard")
    }
    
    /// AppBackground.elevated
    public static var appBackgroundElevated: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appBackgroundElevated")
    }
    
    // MARK: - AppText Colors
    
    /// AppText.heading
    public static var appTextHeading: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appTextHeading")
    }
    
    /// AppText.body
    public static var appTextBody: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appTextBody")
    }
    
    /// AppText.caption
    public static var appTextCaption: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appTextCaption")
    }
    
    /// AppText.onPrimary
    public static var appTextOnPrimary: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appTextOnPrimary")
    }
    
    // MARK: - AppBrand Colors
    
    /// AppBrand.main
    public static var appBrandMain: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appBrandMain")
    }
    
    /// AppBrand.accent
    public static var appBrandAccent: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appBrandAccent")
    }
    
    /// AppBrand.subtle
    public static var appBrandSubtle: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appBrandSubtle")
    }
    
    // MARK: - AppState Colors
    
    /// AppState.success
    public static var appStateSuccess: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appStateSuccess")
    }
    
    /// AppState.warning
    public static var appStateWarning: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appStateWarning")
    }
    
    /// AppState.danger
    public static var appStateDanger: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appStateDanger")
    }
    
    /// AppState.info
    public static var appStateInfo: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appStateInfo")
    }
    
    // MARK: - AppBorder Colors
    
    /// AppBorder.light
    public static var appBorderLight: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appBorderLight")
    }
    
    /// AppBorder.medium
    public static var appBorderMedium: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appBorderMedium")
    }
    
    /// AppBorder.accent
    public static var appBorderAccent: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "appBorderAccent")
    }
}

// MARK: - Code Generation Helper

/// Utility for generating color extensions from discovered JSON colors
public class ColorExtensionGenerator {
    
    /// Generate Swift code for color extensions based on discovered colors
    /// This can be used to create a compile-time generated file
    public static func generateExtensions(from discoveryResult: ColorDiscoveryResult) -> String {
        var code = """
// Colors+Generated.swift
// Auto-generated color extensions based on JSON discovery
// DO NOT EDIT MANUALLY - Regenerate when JSON changes

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(UIKit)
import UIKit
#endif

extension Colors {

"""
        
        // Group by category for better organization
        let sortedCategories = discoveryResult.categories.sorted()
        
        for category in sortedCategories {
            guard let categoryColors = discoveryResult.categorizedColors[category] else { continue }
            
            code += "    // MARK: - \\(category.capitalized) Colors\\n\\n"
            
            let sortedColors = categoryColors.sorted { $0.key < $1.key }
            for (propertyName, _) in sortedColors {
                if let originalKey = discoveryResult.propertyMappings[propertyName] {
                    code += """
    /// \\(originalKey)
    public static var \\(propertyName): DynamicColorProperty {
        return DynamicColorProperty(propertyName: \"\\(propertyName)\")
    }
    
"""
                }
            }
        }
        
        code += """
}

// MARK: - Available Colors Summary

/*
Total Colors: \\(discoveryResult.totalColorCount)
Categories: \\(discoveryResult.categories.joined(separator: ", "))

Property Mappings:
"""
        
        let sortedMappings = discoveryResult.propertyMappings.sorted { $0.key < $1.key }
        for (propName, jsonKey) in sortedMappings {
            code += "• .\\(propName) → \"\\(jsonKey)\"\\n"
        }
        
        code += """
*/

"""
        
        return code
    }
    
    /// Write generated extensions to a file
    /// This is useful for build-time code generation
    public static func writeExtensions(
        from discoveryResult: ColorDiscoveryResult,
        to filePath: String
    ) throws {
        let code = generateExtensions(from: discoveryResult)
        try code.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
}

// MARK: - ColorKit Integration

extension ColorKit {
    
    /// Generate and print color extensions code
    /// This can be copy-pasted to update the generated extensions
    public static func printGeneratedExtensions() {
        guard let dynamicProvider = shared.dynamicProvider,
              let discoveryResult = dynamicProvider.discoveryResult else {
            print("❌ ColorKit: No dynamic colors loaded. Call ColorKit.configure() first.")
            return
        }
        
        print("🎨 Generated Color Extensions:")
        print("Copy the following code to update Colors+Generated.swift:\\n")
        print(ColorExtensionGenerator.generateExtensions(from: discoveryResult))
    }
    
    /// Write generated extensions to a file
    /// - Parameter filePath: Target file path
    public static func writeGeneratedExtensions(to filePath: String) throws {
        guard let dynamicProvider = shared.dynamicProvider,
              let discoveryResult = dynamicProvider.discoveryResult else {
            throw ColorProviderError.mappingError("No dynamic colors loaded")
        }
        
        try ColorExtensionGenerator.writeExtensions(from: discoveryResult, to: filePath)
        print("✅ Generated extensions written to: \\(filePath)")
    }
}