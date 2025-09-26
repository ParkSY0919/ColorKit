# ColorKit 🎨

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS 14+](https://img.shields.io/badge/iOS-14+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 11+](https://img.shields.io/badge/macOS-11+-blue.svg)](https://developer.apple.com/macos/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**ColorKit**은 JSON 디자인 토큰으로부터 자동으로 색상을 탐지하고 관리하는 강력하고 유연한 Swift 패키지입니다. **모든 색상 이름 방식을 지원** - `bg1`, `background-primary`, `Background.primary` 등 어떤 이름이든 가능합니다. 설정이 전혀 필요 없습니다 - JSON 파일만 추가하면 완전한 타입 안전성과 자동 다크 모드 지원으로 색상을 바로 사용할 수 있습니다.

[한국어 README](README_KR.md) | [English README](README.md)

---

## ✨ 주요 기능

- **🚀 제로 설정**: JSON 파일만 추가하면 끝 - 매핑 설정 불필요
- **🎯 다중 접근 패턴**: 프로퍼티 방식, 서브스크립트, 문자열 기반 접근
- **🌙 자동 다크 모드**: 라이트/다크 테마 자동 지원
- **📱 SwiftUI & UIKit**: 두 프레임워크 완전 지원
- **🔍 스마트 탐지**: 모든 색상 이름 지원 - `bg1`, `primaryColor`, `Brand.main` 등
- **⚡ 타입 안전성**: IDE 자동완성과 컴파일 타임 안전성
- **🎨 유연한 JSON 지원**: Figma 익스포트, 커스텀 토큰, 중첩 구조 지원

## 🚀 빠른 시작

### 1. ColorKit 설치

Swift Package Manager로 프로젝트에 ColorKit 추가:

#### Xcode에서

1. **File > Add Package Dependencies** 선택
2. 저장소 URL 입력: `https://github.com/ParkSY0919/ColorKit.git`
3. **Up to Next Major Version** 선택 후 `0.1.0` 입력
4. **Add Package** 클릭

#### Package.swift에서

```swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "0.1.0")
]
```

#### CocoaPods 사용

```ruby
pod 'ColorKit', '~> 0.1'
```

#### Carthage 사용

```
github "ParkSY0919/ColorKit" ~> 0.1
```

### 2. 색상 JSON 파일 추가

ColorKit은 모든 JSON 색상 구조를 지원합니다! 다음은 예시입니다:

**간단한 형태:**

```json
{
  "bg1": "#FFFFFF",
  "bg2": "#F5F5F5",
  "text1": "#000000",
  "text2": "#666666",
  "accent": "#007AFF"
}
```

**중첩 구조 (Figma 익스포트처럼):**

```json
{
  "Background": {
    "primary": "#FFFFFF",
    "secondary": "#F5F5F5"
  },
  "Text": {
    "primary": "#000000",
    "secondary": "#666666"
  },
  "Brand": {
    "primary": "#007AFF"
  }
}
```

### 3. ColorKit 설정

App 파일이나 앱 생명주기 초기에:

```swift
import ColorKit

@main
struct MyApp: App {
    init() {
        // 어떤 JSON 파일 이름도 가능 - ColorKit이 자동으로 라이트/다크 변형을 감지합니다!
        ColorKit.configure(jsonFileName: "app-colors")
        // 자동으로 다음을 찾습니다:
        // - app-colors-light.json + app-colors-dark.json (별도 테마 파일용)
        // - 또는 app-colors.json (임베디드 테마가 있는 단일 파일용)

        // 선택사항: 설정 검증
        ColorKit.validateSetup()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 4. 모든 곳에서 색상 사용

ColorKit이 JSON 색상 이름을 Swift 속성으로 자동 변환합니다:

```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("환영합니다!")
                .foregroundColor(Colors.color(forKey: "Background.primary")?.color ?? .primary)
                .background(Colors.color(forKey: "Text.primary")?.color ?? .black)

            Button("시작하기") {
                // 액션
            }
            .foregroundColor(Colors.color(forKey: "Brand.primary")?.color ?? .blue)
        }
        .background(Colors.color(forKey: "Background.secondary")?.color ?? .gray)
    }
}
```

**간단한 이름("bg1", "bg2" 같은)의 경우:**

```swift
Text("안녕하세요")
    .foregroundColor(Colors.color(forKey: "bg1")?.color ?? .black)
    .background(Colors.color(forKey: "text1")?.color ?? .white)
```

## 🎯 다중 접근 패턴

ColorKit은 모든 명명 규칙을 지원하는 여러 색상 접근 방법을 제공합니다:

### 1. 동적 색상 접근 (권장)

```swift
// 자동 탐지를 통한 동적 공급자로 색상 접근
if let theme = Colors.color(forKey: "backgroundPrimary") {
    Text("안녕하세요").foregroundColor(theme.color)
}

// 또는 프로퍼티 이름 사용
if let theme = Colors.color(forProperty: "backgroundPrimary") {
    Text("안녕하세요").foregroundColor(theme.color)
}

// 둘 다 자동 라이트/다크 지원하는 ColorTheme 반환
```

### 2. 문자열 기반 접근

```swift
// JSON 키 이름을 사용한 직접 접근
if let colorTheme = ColorKit.shared.dynamicProvider?.colorTheme(forKey: "background-primary") {
    Text("안녕하세요").foregroundColor(colorTheme.color)
}

// 모든 JSON 구조와 호환 - 중첩, 케밥케이스 등
ColorKit.shared.dynamicProvider?.colorTheme(forKey: "Brand.primary")
ColorKit.shared.dynamicProvider?.colorTheme(forKey: "success-green")
```

### 3. 생성된 Colors 열거형 (빌드 플러그인 통해)

```swift
// 빌드 플러그인 사용 시, 생성된 열거형 케이스 접근:
Colors.brandPrimary     // 디자인 토큰에서 생성
Colors.backgroundMain   // 자동완성과 타입 안전성
Colors.successGreen     // 모든 색상이 열거형 케이스로 사용 가능
```

### 🎨 JSON 명명 모범 사례

#### ✅ 권장: 카멜케이스 (깔끔한 프로퍼티 접근)

```json
{
  "primaryButton": "#007AFF",
  "successGreen": "#34C759",
  "errorRed": "#FF3B30",
  "backgroundMain": "#FFFFFF"
}
```

```swift
// 깔끔하고 타입 안전한 프로퍼티 접근:
Button("제출")
    .foregroundColor(Colors.primaryButton.color)
    .background(Colors.successGreen.color)
```

#### 🔄 대안: 케밥케이스/특수문자 (서브스크립트 접근)

```json
{
  "primary-button": "#007AFF",
  "success-green": "#34C759",
  "error-red": "#FF3B30",
  "background.main": "#FFFFFF"
}
```

```swift
// 폴백 색상과 함께 서브스크립트 접근 (안전성을 위해 권장):
Button("제출")
    .foregroundColor(Colors["primary-button"]?.color ?? .blue)
    .background(Colors["success-green"]?.color ?? .green)
```

#### 📦 Figma/디자인 툴 익스포트

대부분의 디자인 툴은 케밥케이스나 점을 사용해 익스포트합니다. ColorKit이 완벽하게 처리합니다:

```json
{
  "color/brand/primary": "#007AFF",
  "text-heading-large": "#000000",
  "background.surface.elevated": "#F5F5F5"
}
```

```swift
// 디자인 툴 익스포트에는 서브스크립트 접근 사용:
Colors["color/brand/primary"]?.color ?? .blue
Colors["text-heading-large"]?.color ?? .black
Colors["background.surface.elevated"]?.color ?? .gray
```

#### 🏗️ 중첩 구조 (모든 접근 방법 가능)

```json
{
  "Button": {
    "primary": "#007AFF",
    "secondary": "#5856D6"
  }
}
```

```swift
// 중첩 구조에서는 둘 다 작동:
Colors["Button.primary"]?.color     // 명시적 경로
Colors.buttonPrimary.color          // 자동 생성된 프로퍼티 (사용 가능한 경우)
```

> **💡 팁**: 가장 깔끔한 Swift 코드를 위해서는 JSON에서 카멜케이스를 사용하세요. 하지만 ColorKit은 필요한 모든 명명 규칙을 지원합니다!

## 🎨 지원하는 JSON 구조

ColorKit은 다양한 JSON 색상 형태를 자동으로 처리합니다. **색상 이름은 모든 것이 가능** - ColorKit이 당신의 명명 규칙에 맞추어 작동합니다:

### 단순 키-값 구조 (모든 이름 가능!)

```json
{
  "bg1": "#FFFFFF",
  "bg2": "#F5F5F5",
  "text1": "#000000",
  "accent": "#007AFF",
  "primaryColor": "#5856D6"
}
```

### 중첩 객체 구조

```json
{
  "brand": {
    "primary": "#007AFF",
    "secondary": "#5856D6"
  },
  "text": {
    "heading": "#000000",
    "body": "#333333"
  }
}
```

### Figma 디자인 토큰

```json
{
  "color": {
    "brand": {
      "primary": {
        "500": {
          "value": "#007AFF",
          "type": "color"
        }
      }
    }
  }
}
```

### 배열 형태

```json
[
  {
    "name": "brand-primary",
    "value": "#007AFF"
  },
  {
    "name": "text-heading",
    "value": "#000000"
  }
]
```

## 🌙 자동 라이트/다크 모드 지원

ColorKit은 라이트 및 다크 테마를 처리하는 **세 가지 방법**을 제공하며, 자동으로 최적의 방식을 감지합니다:

### 방법 1: 별도 라이트/다크 JSON 파일 (권장) 🆕

`-light`와 `-dark` 접미사가 붙은 두 개의 JSON 파일을 생성하기만 하면 됩니다:

**app-colors-light.json:**

```json
{
  "bg1": "#FFFFFF",
  "bg2": "#F5F5F5",
  "text1": "#000000",
  "text2": "#666666",
  "accent": "#007AFF",
  "success-green": "#34C759",
  "error-red": "#FF3B30"
}
```

**app-colors-dark.json:**

```json
{
  "bg1": "#000000",
  "bg2": "#1C1C1E",
  "text1": "#FFFFFF",
  "text2": "#AEAEB2",
  "accent": "#0A84FF",
  "success-green": "#30D158",
  "error-red": "#FF453A"
}
```

**코드 변경이 전혀 필요 없습니다!** ColorKit이 자동으로 두 파일을 감지하고 동적 색상 전환을 활성화합니다:

```swift
// 기존과 동일한 설정
ColorKit.configure(jsonFileName: "app-colors")

// 색상이 자동으로 라이트/다크 테마 간 전환됩니다
Text("안녕하세요")
    .foregroundColor(Colors.text1.color)     // 다크모드에서 흰색, 라이트모드에서 검정색
    .background(Colors.bg1.color)            // 다크모드에서 검정색, 라이트모드에서 흰색
```

### 방법 2: 임베디드 라이트/다크 구조

```json
{
  "background-main": {
    "light": "#FFFFFF",
    "dark": "#000000"
  },
  "text-primary": {
    "light": "#000000",
    "dark": "#FFFFFF"
  }
}
```

### 방법 3: 단일 색상 (라이트/다크 동일)

```json
{
  "brand-primary": "#007AFF" // 라이트/다크 동일 색상
}
```

### 🚀 스마트 폴백 시스템

ColorKit이 자동으로 사용 가능한 최적의 방법을 선택합니다:

1. **`-light.json`과 `-dark.json` 모두 존재하는 경우** → 별도 파일 사용 (방법 1)
2. **단일 JSON만 존재하는 경우** → 임베디드 라이트/다크 구조 확인 (방법 2)
3. **둘 다 없는 경우** → 두 테마에 동일한 색상 사용 (방법 3)

### ✨ 실시간 테마 전환

사용자가 기기 설정에서 라이트와 다크 모드를 전환할 때 색상이 자동으로 적응합니다:

```swift
// 추가 코드 불필요 - 자동 테마 전환!
VStack {
    Text("동적 텍스트")
        .foregroundColor(Colors.text1.color)        // 자동 적응

    Rectangle()
        .fill(Colors.bg2.color)                     // 자동 적응

    Button("액션") { }
        .foregroundColor(Colors["error-red"]?.color) // 모든 명명 방식과 호환
}
.background(Colors.bg1.color)                       // 배경도 자동 적응
```

## 🏗️ 빌드 플러그인 & 코드 생성

ColorKit은 Figma 디자인 토큰에서 Swift 색상 열거형을 자동으로 생성하는 강력한 빌드 플러그인을 포함합니다:

### 빌드 플러그인 설정

1. **디자인 토큰 파일을** 타겟의 `Resources/design-tokens/` 디렉터리에 추가:

   - `light.tokens.json` - Figma의 라이트 테마 색상
   - `dark.tokens.json` - Figma의 다크 테마 색상
   - `primitive.tokens.json` - 기본 색상 정의

2. **플러그인이 빌드 중 자동 실행**되어 생성합니다:
   - `Colors.swift` - 모든 색상의 타입 안전한 열거형
   - `ColorThemes.swift` - 내부 테마 데이터

### Figma 토큰 형식

```json
// light.tokens.json
{
  "brand": {
    "primary": {
      "$type": "color",
      "$value": "#007AFF"
    }
  },
  "text": {
    "heading": {
      "$type": "color",
      "$value": "{color.primitive.gray.900}"
    }
  }
}

// primitive.tokens.json
{
  "color": {
    "primitive": {
      "gray": {
        "900": {
          "$type": "color",
          "$value": "#000000"
        }
      }
    }
  }
}
```

### 생성된 색상 사용

```swift
// 생성된 색상의 타입 안전한 접근
Colors.brandPrimary      // "brand.primary"에서
Colors.textHeading       // "text.heading"에서

// 자동 라이트/다크 테마 지원
Text("안녕하세요")
    .foregroundColor(Colors.brandPrimary.color)  // 시스템 테마에 자동 적응
```

## 🔧 고급 사용법

### 색상 탐지 및 내부 검사

```swift
// 사용 가능한 모든 색상 가져오기 (동적 공급자에서)
if let dynamicProvider = ColorKit.shared.dynamicProvider {
    let allColors = dynamicProvider.allColorNames
    print("사용 가능한 색상: \(allColors)")

    let colorsByCategory = dynamicProvider.colorsByCategory
    print("카테고리별 색상: \(colorsByCategory)")
}
```

### 검증 및 디버깅

```swift
// 설정 검증
ColorKit.validateSetup()

// 디버깅용 모든 색상 출력
ColorKit.printAllColors()

// ColorKit 준비 상태 확인
if ColorKit.isReady {
    print("✅ ColorKit이 \(ColorKit.totalColorCount)개 색상을 로드했습니다")
} else {
    print("❌ ColorKit 설정 실패: \(ColorKit.setupError ?? "알 수 없는 오류")")
}
```

### 레거시 매핑 지원 (선택사항)

고급 사용 케이스를 위해 매핑 시스템을 여전히 사용할 수 있습니다:

```swift
let mappings = ColorMappingSet([
    ColorMapping(jsonColorName: "brand-primary", role: .primary),
    ColorMapping(jsonColorName: "success-green", role: .success)
])

ColorKit.configure(with: mappings, jsonFileName: "app-colors")

// 역할을 통한 접근
AppColors.primary.color
AppColors.success.color
```

## 🏗️ 통합 예시

### SwiftUI 예시

```swift
struct MyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("제목")
                .foregroundColor(Colors.textPrimary.color)     // "Text.primary"에서
                .font(.title)

            Text("부제목")
                .foregroundColor(Colors.textSecondary.color)   // "Text.secondary"에서
                .font(.body)

            Button("액션") {
                // 액션 처리
            }
            .foregroundColor(.white)
            .background(Colors.brandPrimary.color)          // "Brand.primary"에서
            .cornerRadius(8)
        }
        .padding()
        .background(Colors.backgroundPrimary.color)         // "Background.primary"에서
    }
}
```

### UIKit 예시

```swift
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundPrimary.uiColor   // "Background.primary"에서

        let titleLabel = UILabel()
        titleLabel.textColor = Colors.textPrimary.uiColor         // "Text.primary"에서
        titleLabel.text = "환영합니다"

        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.brandPrimary.uiColor      // "Brand.primary"에서
        button.setTitle("시작하기", for: .normal)

        // 뷰 계층에 추가...
    }
}
```

## 🎯 실제 사용 시나리오

### 시나리오 1: 스타트업 앱 개발

```swift
// 디자이너가 Figma에서 익스포트한 JSON을 그대로 사용
ColorKit.configure(jsonFileName: "figma-tokens")

// 바로 사용 가능
Text("안녕하세요").foregroundColor(Colors.brandPrimary.color)
```

### 시나리오 2: 기업용 앱 개발

```swift
// 기업 디자인 시스템 JSON 사용
ColorKit.configure(jsonFileName: "corporate-design-system")

// 의미론적 접근
Colors.Brand.main.color
Colors.State.success.color
```

### 시나리오 3: 기존 프로젝트 마이그레이션

```swift
// 기존 하드코딩된 색상들을 JSON으로 이동
// 기존 코드는 그대로 두고 점진적 마이그레이션 가능
```

## 📋 요구 사항

- iOS 14.0+ / macOS 11.0+
- Swift 5.9+
- Xcode 15.0+

## 🤝 기여하기

기여를 환영합니다! Pull Request를 자유롭게 제출해 주세요.

1. 프로젝트 포크
2. 기능 브랜치 생성 (`git checkout -b feature/AmazingFeature`)
3. 변경사항 커밋 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시 (`git push origin feature/AmazingFeature`)
5. Pull Request 열기

## 🔧 문제 해결

### 색상이 로드되지 않을 때

```swift
// 앱 시작 시 추가
ColorKit.validateSetup()
```

### 빌드 이슈

1. JSON 파일이 올바른 위치에 있는지 확인
2. JSON 파일 형식이 예시와 일치하는지 확인
3. Xcode에서 **Product → Clean Build Folder** 실행

### 색상이 보이지 않을 때

- JSON 파일 문법 확인
- 색상 값이 올바른 hex 형식인지 확인
- 파일명과 configure 함수의 파라미터가 일치하는지 확인

## 💡 왜 ColorKit인가?

### 기존 방식의 문제점:

- **Asset Catalog 관리의 번거로움**: 색상마다 수동 등록 필요
- **하드코딩된 색상값**: 변경 시 여러 파일 수정 필요
- **복잡한 다크모드 설정**: 각 색상마다 라이트/다크 버전 별도 관리
- **디자인 시스템과의 불일치**: Figma 변경사항을 수동으로 반영

### ColorKit의 해결책:

- **🚀 자동화**: JSON 파일만으로 모든 색상 자동 생성
- **🎯 타입 안전성**: 컴파일 타임에 색상 존재 여부 확인
- **🌙 스마트 다크모드**: 자동 라이트/다크 테마 전환
- **🔄 동기화**: Figma 익스포트를 바로 사용 가능
- **📱 크로스 플랫폼**: SwiftUI와 UIKit 모두 지원

## 📄 라이선스

ColorKit은 MIT 라이선스 하에 제공됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.
