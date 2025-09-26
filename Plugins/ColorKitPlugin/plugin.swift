// ColorKit Build Tool Plugin

import PackagePlugin
import Foundation

@main
struct ColorKitPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        
        let outputDir = context.pluginWorkDirectory.appending("Generated")
        let tokensDir = target.directory.appending("Resources/design-tokens")
        
        return [
            .buildCommand(
                displayName: "Generate Colors from Design Tokens",
                executable: try context.tool(named: "ColorGenerator").path,
                arguments: [
                    tokensDir.string,
                    outputDir.string
                ],
                inputFiles: [
                    tokensDir.appending("light.tokens.json"),
                    tokensDir.appending("dark.tokens.json"),
                    tokensDir.appending("primitive.tokens.json")
                ],
                outputFiles: [
                    outputDir.appending("Colors.swift"),
                    outputDir.appending("ColorThemes.swift")
                ]
            )
        ]
    }
}
