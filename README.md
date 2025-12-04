# ColorKit

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-F05138.svg)](https://swift.org)
[![iOS 13+](https://img.shields.io/badge/iOS-13+-000000.svg)](https://developer.apple.com/ios/)
[![macOS 10.15+](https://img.shields.io/badge/macOS-10.15+-000000.svg)](https://developer.apple.com/macos/)
[![SPM](https://img.shields.io/badge/SPM-compatible-4BC51D.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

JSON 기반 디자인 토큰을 Swift에서 타입 안전하게 사용할 수 있는 색상 관리 라이브러리입니다. 별도의 매핑 설정 없이 JSON 파일만 추가하면 즉시 사용 가능합니다.

[English](README.md) | [한국어](README_KR.md) | [데모 가이드](Documentations/ColorKitDemo_README_KR.md)

---

## Features

| 기능 | 설명 |
|------|------|
| **Zero Configuration** | JSON 파일 추가만으로 즉시 사용 |
| **Multiple Access Patterns** | DynamicMemberLookup, subscript, 문자열 기반 접근 |
| **Auto Fallback** | 존재하지 않는 색상은 `Color.gray`로 안전하게 폴백 |
| **Auto Dark Mode** | Light/Dark 테마 자동 전환 |
| **SwiftUI & UIKit** | 두 프레임워크 모두 지원 |
| **Flexible JSON** | 플랫 구조, 중첩 객체, Figma 토큰 형식 지원 |

---

## Installation

### Swift Package Manager

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "0.2.0")
]
```

**Xcode**: File > Add Package Dependencies > `https://github.com/ParkSY0919/ColorKit.git`

---

## Quick Start

### 1. JSON 파일 추가

```json
// app-colors.json
{
  "primary": "#007AFF",
  "background": "#FFFFFF",
  "text": "#000000"
}
```

### 2. 초기화

```swift
import ColorKit

@main
struct MyApp: App {
    init() {
        ColorKit.configure(jsonFileName: "app-colors")
    }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

### 3. 사용

```swift
Text("Hello")
    .foregroundColor(Colors.text.color)
    .background(Colors.background.color)
```

---

## Architecture

```
Sources/ColorKit/
├── ColorKit.swift              # 메인 인터페이스
├── ColorProvider.swift         # 색상 제공 프로토콜 및 JSON 로더
├── Colors+Dynamic.swift        # @dynamicMemberLookup 기반 접근
├── Colors+Generated.swift      # 사전 정의된 속성
├── JSONParser.swift            # 유연한 JSON 파싱
├── ColorRole.swift             # 시맨틱 역할 정의
└── ColorRole+Extensions.swift  # SwiftUI/UIKit 변환
```

### 설계 원칙

- **Protocol-Oriented**: `ColorProvider` 프로토콜로 다양한 색상 소스 지원
- **@dynamicMemberLookup**: JSON 키를 Swift 프로퍼티처럼 접근
- **Auto Discovery**: JSON 구조를 런타임에 분석하여 자동 매핑

---

## Color Access

### Dynamic Member Lookup

```swift
Colors.brandPrimary.color       // "brand-primary" or "brandPrimary"
Colors.textHeading.color        // kebab-case 자동 변환
```

### Subscript

```swift
Colors["brand-primary"]?.color ?? .blue
Colors["Background.main"]?.color ?? .gray
```

### String-Based

```swift
if let theme = Colors.color(named: "primary") {
    view.foregroundColor(theme.color)
}
```

### Convenience Namespace

```swift
Colors.Background.main.color
Colors.Text.heading.color
Colors.Brand.main.color
Colors.State.success.color
```

---

## JSON Formats

### Simple

```json
{ "primary": "#007AFF", "secondary": "#5856D6" }
```

### Nested

```json
{
  "Brand": { "primary": "#007AFF" },
  "Text": { "heading": "#000000" }
}
```

### Light/Dark Embedded

```json
{
  "background": { "light": "#FFFFFF", "dark": "#000000" }
}
```

### Figma Tokens

```json
{
  "brand": {
    "primary": { "$type": "color", "$value": "#007AFF" }
  }
}
```

---

## Theme Support

### 자동 테마 감지

| 패턴 | 상태 |
|------|------|
| `{name}-light.json` + `{name}-dark.json` | 지원 |
| `{name}Light.json` + `{name}Dark.json` | 미지원 |

```json
// app-colors-light.json
{ "bg": "#FFFFFF", "text": "#000000" }

// app-colors-dark.json
{ "bg": "#000000", "text": "#FFFFFF" }
```

```swift
ColorKit.configure(jsonFileName: "app-colors")
// Light/Dark 파일 자동 감지 및 로드
```

---

## Fallback System

```swift
// 존재하지 않는 색상도 안전하게 처리
Colors.futureColor.color    // Color.gray 반환
Colors.newFeature.color     // 크래시 없음

// 디버그 모드에서 경고 출력
// ⚠️ ColorKit: Color 'futureColor' not found. Using fallback.
```

UI 코드를 먼저 작성하고, 디자인 토큰은 나중에 추가하는 점진적 개발이 가능합니다.

---

## Build Plugin

Figma 디자인 토큰에서 Swift 코드를 자동 생성합니다.

### 설정

1. `Resources/design-tokens/` 디렉토리에 토큰 파일 추가
   - `light.tokens.json`
   - `dark.tokens.json`
   - `primitive.tokens.json`

2. 빌드 시 자동 생성
   - `Colors.swift`
   - `ColorThemes.swift`

---

## Debug

```swift
ColorKit.validateSetup()      // 설정 상태 출력
ColorKit.printAllColors()     // 로드된 색상 목록

if ColorKit.isReady {
    print("Loaded: \(ColorKit.totalColorCount) colors")
}
```

---

## UIKit Support

```swift
view.backgroundColor = Colors.background.uiColor
label.textColor = Colors.text.uiColor
button.backgroundColor = Colors.primary.uiColor
```

---

## Demo

`ColorKit-Demo/` 폴더에서 모든 기능을 확인할 수 있습니다.

```bash
cd ColorKit-Demo && open ColorKitDemo.xcodeproj
```

자세한 내용은 [데모 가이드](Documentations/ColorKitDemo_README_KR.md)를 참고하세요.

---

## Requirements

- iOS 13.0+ / macOS 10.15+
- Swift 5.9+
- Xcode 15.0+

---

## License

MIT License. 자세한 내용은 [LICENSE](Documentations/LICENSE)를 참고하세요.

---

[GitHub](https://github.com/ParkSY0919/ColorKit) | [Issues](https://github.com/ParkSY0919/ColorKit/issues)
