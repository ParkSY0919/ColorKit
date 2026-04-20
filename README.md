# ColorKit

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2014+%20%7C%20macOS%2011+-blue.svg)](https://developer.apple.com/swift/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[한국어](Documentation/README_KR.md)

JSON design tokens to Swift colors. Zero configuration required. with Claude Code

## Features

- Auto-discovers colors from JSON files
- Light/Dark mode with automatic switching
- Multiple access patterns (property, subscript, namespace)
- Fallback system for missing colors
- SwiftUI and UIKit support
- Figma token compatible

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "0.2.0")
]
```

### Xcode

1. File → Add Package Dependencies
2. Enter `https://github.com/ParkSY0919/ColorKit.git`
3. Assign both **ColorKit** and **ColorKitPlugin** to your target

## Quick Start

**1. Add JSON file to your project**

Create `colors.json` and add it to your Xcode project:
- Drag the file into Xcode
- Check "Copy items if needed"
- Check your app target in "Add to targets"

```json
{
  "brand-primary": "#007AFF",
  "background-main": "#FFFFFF",
  "text-heading": "#1D1D1F"
}
```

**2. Configure at app launch**

Pass the file name (without `.json` extension) to `configure()`:

```swift
import ColorKit

@main
struct MyApp: App {
    init() {
        ColorKit.configure(jsonFileName: "colors")  // loads colors.json
    }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

**3. Use colors**

```swift
Text("Hello")
    .foregroundColor(Colors.textHeading.color)
    .background(Colors.backgroundMain.color)
```

## Dark Mode

Create separate files with `-light` and `-dark` suffixes:

```
colors-light.json
colors-dark.json
```

Colors switch automatically based on system appearance.

## Access Patterns

```swift
// Property access (recommended)
Colors.brandPrimary.color

// Subscript for exact keys
Colors["brand-primary"]?.color ?? .blue

// Namespace access
Colors.Brand.primary.color
Colors.Background.main.color
```

## Documentation

- [Detailed Guide](Documentation/GUIDE_EN.md) - API reference, configuration options
- [Demo App Guide](Documentation/DEMO_EN.md) - Running and exploring the demo

## Requirements

- iOS 14.0+ / macOS 11.0+
- Swift 5.9+
- Xcode 15.0+

## License

MIT License. See [LICENSE](LICENSE) for details.
