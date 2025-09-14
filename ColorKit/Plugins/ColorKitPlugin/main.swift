// main.swift
// ColorKit Build Tool Plugin

import Foundation
import PackagePlugin

@main
struct ColorKitPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        
        // Look for design tokens in the target's directory first, then package directory
        let possibleTokenPaths = [
            target.directory.appending("Resources/design-tokens"),
            context.package.directory.appending("Resources/design-tokens")
        ]
        
        var tokensDirectory: Path?
        for path in possibleTokenPaths {
            if FileManager.default.fileExists(atPath: path.string) {
                tokensDirectory = path
                break
            }
        }
        
        guard let tokensDir = tokensDirectory else {
            // No tokens directory found, return empty commands
            print("⚠️ ColorKit: No design-tokens directory found. Skipping color generation.")
            return []
        }
        
        let outputDirectory = context.pluginWorkDirectory.appending("GeneratedSources")
        
        // Collect input files that actually exist
        let possibleInputFiles = [
            tokensDir.appending("light.tokens.json"),
            tokensDir.appending("dark.tokens.json"),
            tokensDir.appending("primitive.tokens.json")
        ]
        
        let existingInputFiles = possibleInputFiles.filter { 
            FileManager.default.fileExists(atPath: $0.string)
        }
        
        // If no token files exist, return empty commands
        guard !existingInputFiles.isEmpty else {
            print("⚠️ ColorKit: No token files found in \(tokensDir.string)")
            return []
        }
        
        print("🎨 ColorKit: Found design tokens at \(tokensDir.string)")
        
        return [
            .buildCommand(
                displayName: "Generate Colors from Design Tokens",
                executable: try context.tool(named: "ColorGenerator").path,
                arguments: [
                    tokensDir.string,
                    outputDirectory.string
                ],
                inputFiles: existingInputFiles,
                outputFiles: [
                    outputDirectory.appending("Colors.swift"),
                    outputDirectory.appending("ColorThemes.swift")
                ]
            )
        ]
    }
}
