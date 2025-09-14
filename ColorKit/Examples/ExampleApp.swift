// ExampleApp.swift
// Example of how to use ColorKit in an iOS app

import SwiftUI
import ColorKit

@main
struct ExampleApp: App {
    
    init() {
        // Validate ColorKit setup on app launch
        ColorKit.validateSetup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                // Header
                Text("ColorKit Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Colors.text_primary.color)
                
                // Description
                Text("Automatically generated colors from Figma design tokens")
                    .font(.body)
                    .foregroundColor(Colors.text_secondary.color)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Color Showcase
                VStack(spacing: 16) {
                    colorCard("Background Primary", color: Colors.background_primary)
                    colorCard("Brand Primary", color: Colors.brand_primary)
                    colorCard("Status Success", color: Colors.status_success)
                    colorCard("Status Error", color: Colors.status_error)
                }
                .padding()
                
                // Buttons
                VStack(spacing: 12) {
                    Button("Primary Action") {
                        print("Primary button tapped")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Secondary Action") {
                        print("Secondary button tapped")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                
                Spacer()
                
                // Footer info
                Text("Total Colors: \\(ColorKit.colorCount)")
                    .font(.caption)
                    .foregroundColor(Colors.text_tertiary.color)
            }
            .padding()
            .background(Colors.background_primary.color)
            .navigationBarHidden(true)
        }
    }
    
    private func colorCard(_ name: String, color: Colors) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.color)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Colors.border_default.color, lineWidth: 1)
                )
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(Colors.text_primary.color)
                
                if let theme = ColorKit.theme(for: color) {
                    Text("Light: \\(theme.light) | Dark: \\(theme.dark)")
                        .font(.caption)
                        .foregroundColor(Colors.text_secondary.color)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Colors.background_secondary.color)
        .cornerRadius(12)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Colors.text_inverse.color)
            .padding()
            .background(Colors.brand_primary.color)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Colors.brand_primary.color)
            .padding()
            .background(Colors.background_tertiary.color)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Colors.border_default.color, lineWidth: 1)
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    ContentView()
}