# ColorKit Integration Guide

This guide shows how to integrate ColorKit into your iOS project.

## Step 1: Add ColorKit Dependency

### Option A: Package.swift
```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["ColorKit"]
    )
]
```

### Option B: Xcode
1. File → Add Package Dependencies
2. Enter: `https://github.com/ParkSY0919/ColorKit.git`
3. Select version and add to target

## Step 2: Prepare Design Tokens

Create the following directory structure in your project:

```
YourProject/
├── Sources/
│   └── YourApp/
│       ├── YourApp.swift
│       └── Resources/
│           └── design-tokens/          # ← Create this folder
│               ├── light.tokens.json   # ← Light theme colors
│               ├── dark.tokens.json    # ← Dark theme colors  
│               └── primitive.tokens.json # ← Base color palette
```

## Step 3: Export Colors from Figma

### Using Figma Tokens Plugin
1. Install "Design Tokens" plugin in Figma
2. Export your color tokens as JSON
3. You'll get files similar to the format shown below

### JSON File Examples

**primitive.tokens.json** - Base color palette:
```json
{
  "blue": {
    "100": {
      "$type": "color",
      "$value": "#DBEAFE"
    },
    "500": {
      "$type": "color", 
      "$value": "#3B82F6"
    },
    "900": {
      "$type": "color",
      "$value": "#1E3A8A"
    }
  },
  "gray": {
    "100": {
      "$type": "color",
      "$value": "#F3F4F6"
    },
    "900": {
      "$type": "color",
      "$value": "#111827"
    }
  }
}
```

**light.tokens.json** - Light mode semantic colors:
```json
{
  "Background": {
    "primary": {
      "$type": "color",
      "$value": "#FFFFFF"
    },
    "secondary": {
      "$type": "color", 
      "$value": "{gray.100}"
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

**dark.tokens.json** - Dark mode semantic colors:
```json
{
  "Background": {
    "primary": {
      "$type": "color",
      "$value": "#000000"
    },
    "secondary": {
      "$type": "color",
      "$value": "{gray.900}"
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

## Step 4: Build Your Project

When you build your project, ColorKit will:

1. 🔍 Find your `design-tokens` folder
2. 📖 Parse the JSON files
3. 🔗 Resolve primitive color references
4. ⚙️  Generate Swift code
5. 🏗️  Include generated files in build

You'll see output like:
```
🎨 ColorKit Generator starting...
📁 Tokens path: /path/to/design-tokens
📊 Loaded tokens - Light: 5, Dark: 5, Primitive: 4
🎯 Extracted 12 unique colors
✅ ColorKit: Successfully generated 12 colors
```

## Step 5: Use Colors in Your App

### SwiftUI Example
```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello ColorKit!")
                .foregroundColor(Colors.text_primary.color)
            
            Button("Click Me") {
                // Action
            }
            .foregroundColor(Colors.text_inverse.color)
            .padding()
            .background(Colors.brand_primary.color)
            .cornerRadius(8)
        }
        .padding()
        .background(Colors.background_primary.color)
    }
}
```

### UIKit Example
```swift
import UIKit  
import ColorKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.background_primary.uiColor
        
        let label = UILabel()
        label.text = "Hello ColorKit!"
        label.textColor = Colors.text_primary.uiColor
        
        let button = UIButton()
        button.setTitle("Click Me", for: .normal)
        button.backgroundColor = Colors.brand_primary.uiColor
        button.setTitleColor(Colors.text_inverse.uiColor, for: .normal)
    }
}
```

## Step 6: Validate Setup (Recommended)

Add validation to your app startup:

```swift
// SwiftUI App
@main
struct YourApp: App {
    init() {
        ColorKit.validateSetup() // ← Add this
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// UIKit AppDelegate
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ColorKit.validateSetup() // ← Add this
    return true
}
```

This will output helpful debugging info:
```
🎨 ColorKit Setup Validation:
   Colors loaded: 12
   Status: ✅ Ready
   Sample colors:
     - background_primary: #FFFFFF / #000000
     - text_primary: #111827 / #FFFFFF
     - brand_primary: #3B82F6 / #3B82F6
```

## Generated Code Structure

ColorKit automatically generates:

```swift
// Colors.swift (in your target)
public enum Colors: String, CaseIterable {
    case background_primary    // Background.primary → background_primary
    case background_secondary  // Background.secondary → background_secondary
    case text_primary         // Text.primary → text_primary  
    case brand_primary        // Brand.primary → brand_primary
    // ... more cases based on your JSON
}
```

## Color Naming Convention

JSON structure → Swift enum case:
- `Background.primary` → `background_primary`
- `Text.secondary` → `text_secondary`  
- `Brand.light` → `brand_light`
- `Status.error` → `status_error`

## Advanced Features

### Access Color Data Programmatically
```swift
// Get specific color theme
if let theme = ColorKit.theme(for: .brand_primary) {
    print("Light: \\(theme.light)")
    print("Dark: \\(theme.dark)")
}

// Get all colors
for (name, theme) in ColorKit.allThemes {
    print("\\(name): \\(theme.light) / \\(theme.dark)")
}

// Check status
print("Ready: \\(ColorKit.isReady)")
print("Count: \\(ColorKit.colorCount)")
```

### Error Handling
```swift
if let error = ColorKit.setupError {
    print("ColorKit Error: \\(error)")
}
```

## Troubleshooting

### ❌ "No design-tokens directory found"
- Ensure `Resources/design-tokens/` folder exists
- Check folder is in correct target
- Verify JSON files are present

### ❌ "No token files found"  
- Check JSON file names match exactly:
  - `light.tokens.json`
  - `dark.tokens.json` 
  - `primitive.tokens.json`

### ❌ "Invalid JSON"
- Validate JSON syntax
- Ensure `$type` and `$value` fields exist
- Check for trailing commas

### ❌ Colors showing as pink/magenta
- This indicates missing color theme
- Check enum case name matches generated code
- Verify JSON contains the expected color

### ❌ Build errors
1. **Product → Clean Build Folder**
2. Check JSON file format
3. Restart Xcode if needed

## Best Practices

1. **Consistent Naming**: Use consistent naming in Figma/JSON
2. **Semantic Colors**: Use semantic names (`primary`, `secondary`) not descriptive (`blue`, `red`)
3. **Primitive References**: Use `{primitive.variant}` for consistency
4. **Validation**: Always call `ColorKit.validateSetup()` in debug builds
5. **Documentation**: Document your color system in Figma

## Example Project Structure

```
MyApp/
├── Package.swift (with ColorKit dependency)
├── Sources/
│   └── MyApp/
│       ├── MyApp.swift
│       ├── ContentView.swift
│       └── Resources/
│           └── design-tokens/
│               ├── light.tokens.json
│               ├── dark.tokens.json
│               └── primitive.tokens.json
└── Tests/
    └── MyAppTests/
        └── ColorTests.swift
```

## Migration from Asset Catalogs

1. Export existing colors to Figma
2. Set up design tokens as shown above
3. Replace `Color("colorName")` with `Colors.color_name.color`
4. Replace `UIColor(named: "colorName")` with `Colors.color_name.uiColor`
5. Remove old color assets
6. Test light/dark mode switching

---

Need help? Check the main README or open an issue!
