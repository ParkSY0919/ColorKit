# ColorKit.

A Swift Package that automatically generates type-safe color enums from Figma design tokens, providing seamless light/dark mode support without manual Asset Catalog management.

## Features

- 🎨 **Automatic Code Generation**: Generates Swift color enums from Figma JSON exports
- 🌓 **Light/Dark Mode**: Built-in support for light and dark themes
- 📱 **Cross-Platform**: Works with both UIKit and SwiftUI
- 🔗 **Color References**: Supports primitive color references like `{blue.500}`
- 🚀 **Build-Time Generation**: Colors are generated at build time via Swift Package Manager plugins
- ⚡ **Type Safety**: Compile-time color validation with enum cases

## Installation

### Swift Package Manager

Add ColorKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "1.0.0")
]
```

Or add it via Xcode:
1. **File → Add Package Dependencies**
2. Enter URL: `https://github.com/ParkSY0919/ColorKit.git`

## Usage

### 1. Setup Design Tokens

Create a `Resources/design-tokens/` folder in your project and add your Figma-exported JSON files:

```
YourProject/
├── Sources/
│   └── YourApp/
│       └── Resources/
│           └── design-tokens/
│               ├── light.tokens.json
│               ├── dark.tokens.json
│               └── primitive.tokens.json
```

### 2. JSON File Format

**primitive.tokens.json** (Base color palette):
```json
{
  "blue": {
    "500": {
      "$type": "color",
      "$value": "#3B82F6"
    }
  },
  "gray": {
    "900": {
      "$type": "color", 
      "$value": "#111827"
    }
  }
}
```

**light.tokens.json** (Light theme colors):
```json
{
  "Background": {
    "primary": {
      "$type": "color",
      "$value": "#FFFFFF"
    }
  },
  "Text": {
    "primary": {
      "$type": "color",
      "$value": "{gray.900}"
    }
  },
  "Brand": {
    "primary": {
      "$type": "color",
      "$value": "{blue.500}"
    }
  }
}
```

**dark.tokens.json** (Dark theme colors):
```json
{
  "Background": {
    "primary": {
      "$type": "color",
      "$value": "#000000"
    }
  },
  "Text": {
    "primary": {
      "$type": "color",
      "$value": "#FFFFFF"
    }
  },
  "Brand": {
    "primary": {
      "$type": "color",
      "$value": "{blue.500}"
    }
  }
}
```

### 3. Using Colors in UIKit

```swift
import UIKit
import ColorKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Validate ColorKit setup (optional, recommended for debugging)
        ColorKit.validateSetup()
        
        // Use generated colors
        view.backgroundColor = Colors.background_primary.uiColor
        
        let label = UILabel()
        label.textColor = Colors.text_primary.uiColor
        
        let button = UIButton()
        button.backgroundColor = Colors.brand_primary.uiColor
        button.setTitleColor = Colors.text_primary.uiColor
    }
}
```

### 4. Using Colors in SwiftUI

```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to ColorKit!")
                .foregroundColor(Colors.text_primary.color)
            
            Button("Get Started") {
                // Action
            }
            .foregroundColor(Colors.text_primary.color)
            .padding()
            .background(Colors.brand_primary.color)
            .cornerRadius(8)
        }
        .padding()
        .background(Colors.background_primary.color)
    }
}
```

### 5. Advanced Usage

```swift
import ColorKit

// Access color themes programmatically
if let theme = ColorKit.theme(for: .brand_primary) {
    print("Light: \\(theme.light)")  // #3B82F6
    print("Dark: \\(theme.dark)")    // #3B82F6
}

// Get all available colors
print("Total colors: \\(ColorKit.colorCount)")

// Validate setup
ColorKit.validateSetup()

// Check if ready
if ColorKit.isReady {
    print("ColorKit is ready with \\(ColorKit.colorCount) colors")
}
```

## Generated Code

ColorKit automatically generates two files during build:

**Colors.swift**:
```swift
public enum Colors: String, CaseIterable {
    case background_primary
    case text_primary
    case brand_primary
    // ... more colors
}
```

**ColorThemes.swift** (Internal):
```swift
internal struct ColorThemes {
    static let data: Data? = \"\"\"
    {
      "background_primary": {"light": "#FFFFFF", "dark": "#000000"},
      "text_primary": {"light": "#111827", "dark": "#FFFFFF"}
    }
    \"\"\".data(using: .utf8)
}
```

## Color Extensions

ColorKit adds convenient extensions to access colors:

```swift
// UIKit
let uiColor: UIColor = Colors.brand_primary.uiColor

// SwiftUI  
let color: Color = Colors.brand_primary.color
```

Both automatically handle light/dark mode switching.

## Build Process

1. **JSON Parsing**: Reads design token files at build time
2. **Reference Resolution**: Resolves `{primitive.color}` references
3. **Theme Merging**: Combines light/dark variants
4. **Code Generation**: Creates Swift enum and theme data
5. **Integration**: Files are included in your app bundle

## Troubleshooting

### Colors Not Loading
```swift
// Add to app startup
ColorKit.validateSetup()
```

### Build Issues
1. Ensure `design-tokens` folder is in correct location
2. Verify JSON file format matches examples
3. Run **Product → Clean Build Folder** in Xcode

### Missing Colors
- Check JSON file syntax
- Ensure `$type: "color"` is present
- Verify primitive color references exist

## JSON Requirements

- Files must be valid JSON
- Color objects need `$type: "color"` and `$value` fields
- References use `{category.variant}` format
- Nested objects become underscore-separated names (`Background.primary` → `background_primary`)

## License

MIT License - see LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

---

Built with ❤️ for better iOS design token management.
