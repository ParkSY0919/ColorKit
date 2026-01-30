# ColorKit Demo App Guide

[한국어](DEMO_KR.md)

Learn ColorKit features through the demo app.

---

## Table of Contents

1. [Overview](#overview)
2. [Running the Demo](#running-the-demo)
3. [Demo Screens](#demo-screens)
4. [Testing Features](#testing-features)
5. [Console Output](#console-output)
6. [FAQ](#faq)

---

## Overview

The demo app demonstrates ColorKit's features with three screens:

| Screen | Purpose |
|--------|---------|
| JSON Color Test | Basic JSON-based color system |
| Adaptive Color Test | Light/Dark mode switching |
| Assets Color Test | Comparison with Xcode Assets |

---

## Running the Demo

### Option 1: From Repository

```bash
git clone https://github.com/ParkSY0919/ColorKit.git
cd ColorKit/ColorKit-Demo
open ColorKitDemo.xcodeproj
```

Build and run (⌘R).

### Option 2: From Package

The demo is included in `ColorKit-Demo/` folder when you clone the repository.

### Requirements

- Xcode 15.0+
- iOS 14.0+ Simulator or device

---

## Demo Screens

### 1. JSON Color Test (ContentView)

Tests basic color loading from JSON.

**What you'll see:**
- Colors loaded from `colors.json`
- Property access: `Colors.brandPrimary.color`
- Generated Swift extension code

**Code example from demo:**

```swift
Text("Title")
    .foregroundColor(Colors.textHeading.color)

Button("Action") { }
    .background(Colors.brandPrimary.color)
```

**JSON structure used:**

```json
{
  "brand-primary": "#007AFF",
  "background-main": "#FFFFFF",
  "text-heading": "#000000"
}
```

### 2. Adaptive Color Test (AdaptiveColorTestView)

Tests automatic light/dark mode switching.

**What you'll see:**
- Colors change based on system theme
- In-app dark mode toggle
- Real-time color switching

**Code example from demo:**

```swift
// Same code, different colors per theme
Colors.backgroundMain.color  // Light: #FFFFFF, Dark: #000000
Colors.textHeading.color     // Light: #000000, Dark: #FFFFFF
```

**JSON structure used:**

```json
{
  "background-main": {
    "light": "#FFFFFF",
    "dark": "#000000"
  }
}
```

### 3. Assets Color Test (XcassetsColorTestView)

Compares ColorKit with Xcode Asset Catalog.

**What you'll see:**
- Side-by-side comparison
- ColorKit vs Assets.xcassets vs System colors
- Migration examples

**Code comparison:**

```swift
// ColorKit
Colors.accentPrimary.color

// Asset Catalog
Color("BrandPrimary")

// System
.accentColor
```

---

## Testing Features

### Auto Color Discovery

Check console when app launches:

```
✅ ColorKit: Auto-discovered 19 colors from 'colors.json'
```

### Dark Mode Toggle

1. Go to Adaptive Color Test screen
2. Use the toggle to switch themes
3. Observe color changes

Or use system settings:
- iOS: Settings → Display & Brightness
- Simulator: Features → Toggle Appearance (⇧⌘A)

### Fallback System

The demo includes undefined colors to demonstrate fallbacks:

```swift
Colors.futureColor.color        // Shows gray
Colors.shadowColor.color        // Shows gray (if not defined)
```

Console output:
```
⚠️ ColorKit: Color 'futureColor' not found. Using fallback.
```

### Code Generation

Each screen shows generated Swift code you can copy to your project:

```swift
extension Colors {
    public static var brandPrimary: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "brandPrimary")
    }
}
```

---

## Console Output

### Successful Load

```
✅ ColorKit: Auto-discovered 19 colors from 'colors.json'
```

### Validation Output

```
🎨 ColorKit Setup Validation:
   Mode: Dynamic (auto-discovery)
   Colors loaded: 19
   Status: ✅ Ready
   Categories: Brand, Background, Text, State, Border
   Sample colors:
     - brandPrimary: #007AFF / #0A84FF
     - backgroundMain: #FFFFFF / #000000
```

### Fallback Warnings

```
⚠️ ColorKit: Color 'futureColor' not found. Using fallback.
⚠️ ColorKit: Color 'shadowColor' not found. Using fallback.
```

These warnings are intentional in the demo to show the fallback system.

---

## FAQ

### Q: I see "Color not found" warnings. Is this an error?

No. This is ColorKit's fallback system working correctly. Undefined colors display as gray instead of crashing. The demo includes intentional undefined colors (`futureColor`, etc.) to demonstrate this.

### Q: Colors don't update after editing JSON

Quit the app completely (⌘Q) and restart. ColorKit loads JSON at app launch.

### Q: Which JSON file should I use?

- **Single colors** (`colors.json`): Simple apps, fixed brand colors
- **Adaptive colors** (`colors-adaptive.json`): Apps with dark mode support

### Q: How do I resolve fallback warnings?

1. Switch from single to adaptive JSON
2. Or add missing colors to your JSON file

### Q: Can I copy demo code to my project?

Yes. The generated code shown in the demo can be copied directly to your project.

---

## Project Structure

```
ColorKit-Demo/
├── ColorKitDemo/
│   ├── ColorKit_TestApp.swift      # App entry point
│   ├── ContentView.swift           # JSON Color Test
│   ├── AdaptiveColorTestView.swift # Adaptive Color Test
│   ├── XcassetsColorTestView.swift # Assets Color Test
│   └── CodeGenerationTestView.swift
├── Resources/
│   ├── colors.json                 # Single color JSON
│   └── colors-adaptive.json        # Adaptive color JSON
└── Assets.xcassets/                # Comparison Asset Catalog
```

---

## Using Demo for Testing

### For Developers

- Test ColorKit before integrating
- Experiment with color combinations
- Verify performance

### For Designers

- Review color system implementation
- Check dark mode appearance
- Validate accessibility

### For QA

- Feature testing
- Theme switching testing
- Regression testing

---

[← Back to README](../README.md)
