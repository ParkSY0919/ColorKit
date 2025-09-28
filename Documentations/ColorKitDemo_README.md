# ColorKit Demo App Guide

A comprehensive guide for developers new to ColorKit. Experience and learn all ColorKit features through this demo app.

## 📱 Demo App Overview

The ColorKit Demo App consists of 3 main screens:

1. **JSON Color Test** - JSON-based color system
2. **Adaptive Color Test** - Light/Dark mode adaptive colors
3. **Assets Color Test** - Comparison with Xcode Assets.xcassets colors

## 🎨 Screen-by-Screen Guide

### 1. JSON Color Test (ContentView)

**Purpose**: Learn basic JSON-based color system usage

#### Key Features:
- **Single Color Loading**: Auto-discover colors from `colors.json` file
- **Color Usage**: Access via `Colors.brandPrimary.color` format
- **Real-time Code Generation**: Auto-generate Swift extension code for discovered colors

#### Learning Points:
```swift
// 1. Basic Usage
Colors.brandPrimary.color          // SwiftUI Color
Colors.brandPrimary.uiColor        // UIKit UIColor

// 2. Color Property Access
.background(Colors.backgroundMain.color)
.foregroundColor(Colors.textHeading.color)
```

#### JSON File Structure:
```json
{
  "brand-primary": "#007AFF",
  "background-main": "#FFFFFF",
  "text-heading": "#000000"
}
```

### 2. Adaptive Color Test (AdaptiveColorTestView)

**Purpose**: Master Light/Dark mode adaptive color system

#### Key Features:
- **Adaptive Colors**: Automatic color changes based on light/dark mode
- **Real-time Mode Toggle**: Toggle dark mode within the app
- **Code Generation**: Auto-generate adaptive color extension code

#### Learning Points:
```swift
// Adaptive color usage (auto light/dark switching)
Colors.backgroundMain.color  // Light: #FFFFFF, Dark: #000000
Colors.textHeading.color     // Light: #000000, Dark: #FFFFFF
```

#### Adaptive JSON Structure:
```json
{
  "background-main": {
    "light": "#FFFFFF",
    "dark": "#000000"
  },
  "text-heading": {
    "light": "#000000",
    "dark": "#FFFFFF"
  }
}
```

### 3. Assets Color Test (XcassetsColorTestView)

**Purpose**: Learn comparison between existing Xcode Assets colors and ColorKit

#### Key Features:
- **Color Source Comparison**: Compare JSON vs Assets vs System colors
- **Real Use Cases**: Practical examples with buttons, cards, backgrounds
- **Assets Compatibility**: Understand migration methods from existing projects

#### Learning Points:
```swift
// Comparison of 3 color definition methods
Colors.accentPrimary.color    // JSON-based (ColorKit)
Color("BrandPrimary")         // Assets.xcassets
.accentColor                  // SwiftUI system color
```

## 🚀 Getting Started

### 1. Install ColorKit

**Swift Package Manager**:
```
https://github.com/ParkSY0919/ColorKit.git
```

**Add to Project**:
```swift
import ColorKit
```

### 2. Create JSON Color File

Add `colors.json` file to your project and include in bundle:

```json
{
  "primary": "#007AFF",
  "secondary": "#5AC8FA",
  "background": "#FFFFFF",
  "text": "#000000"
}
```

### 3. Basic Usage

```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello ColorKit!")
                .foregroundColor(Colors.text.color)
                .background(Colors.background.color)
        }
    }
}
```

## 🎯 Experience Key Features

### 1. Auto Color Discovery
Check console output when app launches:
```
✅ ColorKit: Auto-discovered 19 colors from 'colors.json'
```

### 2. Real-time Code Generation
Copy generated code from demo app and apply to your project:
```swift
extension Colors {
    public static var primary: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "primary")
    }
}
```

### 3. Dark Mode Support
Experience real-time mode switching in Adaptive Color Test

### 4. Error Handling & Fallback System
Automatic fallback when using non-existent colors (displays as gray):
```
⚠️ ColorKit: Color 'futureColor' not found. Using fallback.
⚠️ ColorKit: Color 'shadowColor' not found. Using fallback.
⚠️ ColorKit: Color 'backgroundElevated' not found. Using fallback.
```

**Fallback Causes:**
- **Using Single Color JSON**: `shadowColor`, `backgroundElevated` etc. are not defined in some cases
- **Switching to Adaptive Colors**: All colors have light/dark definitions, preventing fallbacks

**Solutions:**
1. **Switch Single → Adaptive Colors**: Use `colors-adaptive.json`
2. **Add Missing Colors**: Define required colors in single color JSON

**Intentional Error Examples in Demo App:**
- `futureColor`: Non-existent color for testing fallback behavior
- `shadowColor`: Missing color in single JSON (defined in adaptive)
- `backgroundElevated`: Missing color in single JSON (defined in adaptive)

These examples are **not actual errors** but educational code demonstrating ColorKit's safe fallback system.

## 💡 Pro Tips

### 1. Naming Conventions
- **Purpose-based**: `background-main`, `text-heading`
- **Hierarchical**: `brand-primary`, `brand-secondary`
- **State-based**: `state-success`, `state-error`

### 2. Choosing JSON vs Adaptive
- **Single Colors**: Simple apps, fixed brand colors needed
- **Adaptive Colors**: Dark mode support, accessibility considerations needed

### 3. Migration Strategy
Gradual migration from existing Assets colors → ColorKit:
```swift
// Before
Color("BrandPrimary")

// After with ColorKit
Colors.brandPrimary.color
```

## 🔧 Customization

### 1. Add Custom Colors
Add new colors to JSON file and restart app:
```json
{
  "custom-accent": "#FF6B6B",
  "custom-background": "#F8F9FA"
}
```

### 2. Change Namespace
Use different name instead of `Colors` if needed

### 3. Set Fallback Colors
Configure default values for non-existent colors

## ⚠️ Important Notes & FAQ

### Q: I see "Color not found" warnings in console. Is this an error?
**A**: No! This is ColorKit's safe fallback system.
- Non-existent colors are replaced with gray
- App continues to work safely without crashes
- Demo app's `futureColor`, etc. are intentional test cases

### Q: I modified the JSON file but changes aren't reflected
**A**: Please completely quit and restart the app. ColorKit loads JSON at app startup.

### Q: Should I choose single colors or adaptive colors?
**A**:
- **Single Colors**: Simple apps, fixed brand colors required (may have some color fallbacks)
- **Adaptive Colors**: Dark mode support, accessibility considerations needed (all colors defined, no fallbacks)

### Q: How to resolve `shadowColor`, `backgroundElevated` fallback warnings?
**A**: Switch from single color JSON to adaptive color JSON.
- **Current**: `colors.json` (single colors) → Some colors missing, causing fallbacks
- **Solution**: `colors-adaptive.json` (adaptive colors) → All colors have light/dark definitions, no fallbacks

### Q: Can I migrate from existing Assets.xcassets colors?
**A**: Yes! You can gradually migrate existing colors to ColorKit while maintaining compatibility.

## 📚 Additional Learning Resources

1. **ColorKit GitHub**: [https://github.com/ParkSY0919/ColorKit.git](https://github.com/ParkSY0919/ColorKit.git)
2. **SwiftUI Color Documentation**: Apple Developer Documentation
3. **Design System Building**: Color system design guidelines

## 🎨 Demo App Usage

### For Developers
- Test new features
- Experiment with color combinations
- Performance verification

### For Designers
- Review color systems
- Check dark mode appearance
- Accessibility validation

### For QA
- Feature testing
- Regression testing
- Usability validation

---

**For questions or improvement suggestions, please submit through GitHub Issues!** 🚀