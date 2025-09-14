// main.swift
// ColorKit Color Generator
// Executable for generating Swift color enums from Figma design tokens

import Foundation

// MARK: - Data Models
struct ColorToken: Codable {
    let type: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case value = "$value"
    }
}

struct ColorTheme: Codable {
    let light: String
    let dark: String
}

// MARK: - Main Generator  
struct ColorGeneratorTool {
    
    func generate(tokensPath: String, outputPath: String) throws {
        // 1. Check if token files exist
        let lightPath = "\(tokensPath)/light.tokens.json"
        let darkPath = "\(tokensPath)/dark.tokens.json"
        let primitivePath = "\(tokensPath)/primitive.tokens.json"
        
        print("🔍 Checking for token files...")
        
        // 2. Load JSON files (allow missing files with fallbacks)
        let lightTokens = try loadTokensIfExists(path: lightPath)
        let darkTokens = try loadTokensIfExists(path: darkPath)
        let primitiveTokens = try loadTokensIfExists(path: primitivePath)
        
        print("📊 Loaded tokens - Light: \(lightTokens.count), Dark: \(darkTokens.count), Primitive: \(primitiveTokens.count)")
        
        // 3. Extract and merge colors
        let lightColors = extractColors(from: lightTokens, primitive: primitiveTokens)
        let darkColors = extractColors(from: darkTokens, primitive: primitiveTokens)
        let mergedColors = mergeColors(light: lightColors, dark: darkColors)
        
        print("🎯 Extracted \(mergedColors.count) unique colors")
        
        // 4. Generate Swift code
        try generateSwiftFiles(colors: mergedColors, outputPath: outputPath)
        
        print("✅ ColorKit: Successfully generated \(mergedColors.count) colors")
    }
    
    private func loadTokensIfExists(path: String) throws -> [String: Any] {
        let url = URL(fileURLWithPath: path)
        guard FileManager.default.fileExists(atPath: path) else {
            print("⚠️  File not found: \(path), using empty tokens")
            return [:]
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        } catch {
            print("❌ Error loading \(path): \(error)")
            throw ColorGeneratorError.invalidJSON(path)
        }
    }
    
    private func extractColors(from tokens: [String: Any], primitive: [String: Any]) -> [String: String] {
        var colors: [String: String] = [:]
        extractColorsRecursive(node: tokens, primitive: primitive, path: [], result: &colors)
        return colors
    }
    
    private func extractColorsRecursive(
        node: [String: Any],
        primitive: [String: Any],
        path: [String],
        result: inout [String: String]
    ) {
        for (key, value) in node {
            // Skip meta keys
            if key.hasPrefix("$") { continue }
            
            if let colorDict = value as? [String: Any],
               let type = colorDict["$type"] as? String,
               type == "color",
               let colorValue = colorDict["$value"] as? String {
                
                let normalizedKey = normalizeKey(path: path + [key])
                let resolvedColor = resolveColorValue(colorValue, primitive: primitive)
                result[normalizedKey] = resolvedColor
                
            } else if let nestedDict = value as? [String: Any] {
                extractColorsRecursive(
                    node: nestedDict,
                    primitive: primitive,
                    path: path + [key],
                    result: &result
                )
            }
        }
    }
    
    private func normalizeKey(path: [String]) -> String {
        return path
            .joined(separator: "_")
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: ".", with: "_")
    }
    
    private func resolveColorValue(_ value: String, primitive: [String: Any]) -> String {
        if value.hasPrefix("#") {
            return value.uppercased()
        }
        
        // Handle {color.variant} references
        if value.hasPrefix("{") && value.hasSuffix("}") {
            let reference = String(value.dropFirst().dropLast())
            return resolvePrimitiveColor(reference: reference, primitive: primitive)
        }
        
        return value
    }
    
    private func resolvePrimitiveColor(reference: String, primitive: [String: Any]) -> String {
        let components = reference.split(separator: ".")
        var current: Any = primitive
        
        for component in components {
            if let dict = current as? [String: Any] {
                current = dict[String(component)] ?? [:]
            }
        }
        
        if let colorDict = current as? [String: Any],
           let value = colorDict["$value"] as? String {
            // Recursively resolve if the primitive also has a reference
            return resolveColorValue(value, primitive: primitive)
        }
        
        print("⚠️  Could not resolve color reference: \(reference)")
        return "#FF00FF" // Fallback magenta color
    }
    
    private func mergeColors(light: [String: String], dark: [String: String]) -> [String: ColorTheme] {
        var merged: [String: ColorTheme] = [:]
        let allKeys = Set(light.keys).union(Set(dark.keys))
        
        for key in allKeys.sorted() {
            let lightColor = light[key] ?? dark[key] ?? "#000000"
            let darkColor = dark[key] ?? light[key] ?? "#FFFFFF"
            merged[key] = ColorTheme(light: lightColor, dark: darkColor)
        }
        
        return merged
    }
    
    private func generateSwiftFiles(colors: [String: ColorTheme], outputPath: String) throws {
        let outputURL = URL(fileURLWithPath: outputPath)
        try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)
        
        // Generate Colors.swift
        try generateColorsEnum(colors: colors, outputURL: outputURL)
        
        // Generate ColorThemes.swift
        try generateColorThemes(colors: colors, outputURL: outputURL)
        
        print("📄 Generated Files:")
        print("   - Colors.swift (\(colors.count) color cases)")
        print("   - ColorThemes.swift (theme data)")
    }
    
    private func generateColorsEnum(colors: [String: ColorTheme], outputURL: URL) throws {
        let sortedKeys = colors.keys.sorted()
        let enumCases = sortedKeys.map { "    case \($0)" }.joined(separator: "\n")
        
        let content = """
        //
        // Colors.swift
        // Auto-generated by ColorKit
        // DO NOT EDIT MANUALLY
        //
        
        import Foundation
        
        /// Auto-generated color enum from design tokens
        /// Each case represents a color that supports both light and dark modes
        public enum Colors: String, CaseIterable {
        \(enumCases)
        }
        """
        
        let fileURL = outputURL.appendingPathComponent("Colors.swift")
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    
    private func generateColorThemes(colors: [String: ColorTheme], outputURL: URL) throws {
        // Convert to JSON format
        let colorData = colors.mapValues { theme in
            ["light": theme.light, "dark": theme.dark]
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: colorData, options: [.prettyPrinted, .sortedKeys])
        let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
        
        let content = """
        //
        // ColorThemes.swift
        // Auto-generated by ColorKit
        // DO NOT EDIT MANUALLY
        //
        
        import Foundation
        
        /// Internal color theme data loaded from design tokens
        internal struct ColorThemes {
            static let data: Data? = \"\"\"
        \(jsonString)
        \"\"\".data(using: .utf8)
        }
        """
        
        let fileURL = outputURL.appendingPathComponent("ColorThemes.swift")
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}

// MARK: - Error Types
enum ColorGeneratorError: Error, LocalizedError {
    case invalidArguments
    case fileNotFound(String)
    case invalidJSON(String)
    case outputError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidArguments:
            return "Invalid command line arguments"
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .invalidJSON(let path):
            return "Invalid JSON in file: \(path)"
        case .outputError(let message):
            return "Output error: \(message)"
        }
    }
}

// MARK: - Main Entry Point
struct ColorGenerator {
    static func main() {
        let args = CommandLine.arguments
        guard args.count >= 3 else {
            print("Usage: ColorGenerator <tokens-path> <output-path>")
            exit(1)
        }

        let tokensPath = args[1]
        let outputPath = args[2]

        print("🎨 ColorKit Generator starting...")
        print("📁 Tokens path: \(tokensPath)")
        print("📂 Output path: \(outputPath)")

        do {
            let generator = ColorGeneratorTool()
            try generator.generate(tokensPath: tokensPath, outputPath: outputPath)
        } catch {
            print("❌ ColorGenerator Error: \(error)")
            exit(1)
        }
    }
}

