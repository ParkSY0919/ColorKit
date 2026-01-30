# ColorKit 가이드

[English](GUIDE_EN.md)

ColorKit API 레퍼런스 및 설정 가이드.

---

## 목차

1. [설치](#설치)
2. [설정](#설정)
3. [JSON 파일 형식](#json-파일-형식)
4. [접근 방식](#접근-방식)
5. [다크 모드 지원](#다크-모드-지원)
6. [빌드 플러그인](#빌드-플러그인)
7. [디버깅](#디버깅)
8. [마이그레이션 가이드](#마이그레이션-가이드)

---

## 설치

### Swift Package Manager

`Package.swift`에 추가:

```swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "0.2.0")
]
```

### Xcode 연동

1. File → Add Package Dependencies
2. 저장소 URL 입력: `https://github.com/ParkSY0919/ColorKit.git`
3. 버전 `0.2.0` 이상 선택
4. **ColorKit (Library)** 를 앱 타겟에 할당
5. **ColorKitPlugin (Executable)** 을 앱 타겟에 할당

ColorKitPlugin을 "None"으로 설정하면:
- 정적 색상 프로퍼티가 생성되지 않음
- IDE 자동완성 제한
- 서브스크립트 접근(`Colors["key"]`)은 사용 가능

### CocoaPods

```ruby
pod 'ColorKit', '~> 0.2'
```

### Carthage

```
github "ParkSY0919/ColorKit" ~> 0.2
```

---

## 설정

### 기본 설정

앱 생명주기 초기에 `configure()` 호출:

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

### UIKit 앱

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ColorKit.configure(jsonFileName: "app-colors")
        return true
    }
}
```

### 검증

ColorKit 로드 상태 확인:

```swift
ColorKit.validateSetup()  // 콘솔에 상태 출력

if ColorKit.isReady {
    print("\(ColorKit.totalColorCount)개 색상 로드됨")
} else {
    print("에러: \(ColorKit.setupError ?? "알 수 없음")")
}
```

---

## JSON 파일 형식

ColorKit은 다양한 JSON 구조를 지원.

### 단순 키-값

```json
{
  "brand-primary": "#007AFF",
  "background-main": "#FFFFFF",
  "text-heading": "#1D1D1F",
  "text-body": "#666666"
}
```

### 중첩 객체

```json
{
  "Brand": {
    "primary": "#007AFF",
    "secondary": "#5856D6"
  },
  "Background": {
    "main": "#FFFFFF",
    "card": "#F2F2F7"
  }
}
```

### Figma 토큰 형식

```json
{
  "color": {
    "brand": {
      "primary": {
        "$type": "color",
        "$value": "#007AFF"
      }
    }
  }
}
```

### 배열 형식

```json
[
  { "name": "brand-primary", "value": "#007AFF" },
  { "name": "text-heading", "value": "#1D1D1F" }
]
```

### 명명 규칙

JSON 키가 Swift 프로퍼티로 변환:

| JSON 키 | Swift 프로퍼티 |
|---------|----------------|
| `brand-primary` | `Colors.brandPrimary` |
| `text-heading` | `Colors.textHeading` |
| `Background.main` | `Colors.backgroundMain` |

---

## 접근 방식

### 1. 프로퍼티 접근 (권장)

```swift
Colors.brandPrimary.color       // SwiftUI Color
Colors.brandPrimary.uiColor     // UIKit UIColor
Colors.brandPrimary.cgColor     // Core Graphics CGColor
```

없는 색상은 `Color.gray`로 폴백:

```swift
Colors.undefinedColor.color     // Color.gray 반환, 크래시 없음
```

### 2. 서브스크립트 접근

정확한 JSON 키 매칭:

```swift
Colors["brand-primary"]?.color ?? .blue
Colors["Background.main"]?.color ?? .white
```

### 3. 네임스페이스 접근

카테고리별 정리:

```swift
// Background
Colors.Background.main.color
Colors.Background.card.color
Colors.Background.elevated.color

// Text
Colors.Text.heading.color
Colors.Text.body.color
Colors.Text.caption.color

// Brand
Colors.Brand.main.color
Colors.Brand.accent.color

// State
Colors.State.success.color
Colors.State.warning.color
Colors.State.danger.color

// Border
Colors.Border.light.color
Colors.Border.medium.color
```

### 4. 문자열 기반 접근

동적 색상 선택:

```swift
if let theme = Colors.color(named: "brand-primary") {
    view.backgroundColor = theme.uiColor
}

let colorName = userSettings.accentColor
Colors.color(named: colorName)?.color ?? .blue
```

---

## 다크 모드 지원

### 방법 1: 별도 파일 (권장)

`-light`, `-dark` 접미사로 파일 생성:

**colors-light.json**
```json
{
  "background": "#FFFFFF",
  "text": "#000000"
}
```

**colors-dark.json**
```json
{
  "background": "#000000",
  "text": "#FFFFFF"
}
```

기본 이름으로 설정:

```swift
ColorKit.configure(jsonFileName: "colors")
// colors-light.json과 colors-dark.json 자동 탐색
```

파일명 요구사항:
- `-light`, `-dark` 접미사 사용 (케밥케이스)
- `colors-light.json` / `colors-dark.json` 가능
- `colorsLight.json` / `colorsDark.json` 불가

### 방법 2: 임베디드 구조

단일 파일에 라이트/다크 값:

```json
{
  "background": {
    "light": "#FFFFFF",
    "dark": "#000000"
  },
  "text": {
    "light": "#000000",
    "dark": "#FFFFFF"
  }
}
```

### 방법 3: 단일 값

두 테마에 동일한 색상:

```json
{
  "brand-primary": "#007AFF"
}
```

---

## 빌드 플러그인

ColorKitPlugin이 Figma 디자인 토큰에서 Swift 코드 생성.

### 설정

1. 토큰 파일을 `Resources/design-tokens/`에 추가:
   - `light.tokens.json`
   - `dark.tokens.json`
   - `primitive.tokens.json` (선택)

2. 빌드 시 플러그인 자동 실행

3. 생성 파일:
   - `Colors.swift` - 타입 안전 색상 열거형
   - `ColorThemes.swift` - 테마 데이터

### 토큰 형식

```json
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
```

---

## 디버깅

### 모든 색상 출력

```swift
ColorKit.printAllColors()
```

출력:
```
brandPrimary: #007AFF → #0A84FF
backgroundMain: #FFFFFF → #000000
textHeading: #1D1D1F → #FFFFFF
```

### 누락된 색상 확인

```swift
// 경고 활성화
ColorKit.enableMissingColorWarnings = true

// 누락된 색상 목록
let missing = ColorKit.requestedMissingColors
print("누락: \(missing)")
```

### 접근 로깅

```swift
ColorKit.enableAccessLogging = true
// 모든 색상 접근 시도 로그
```

### 설정 검증

```swift
// ColorKit 로드 성공 여부 확인
ColorKit.validateSetup()

// 또는 프로그래밍 방식으로 확인
if ColorKit.isReady {
    print("\(ColorKit.totalColorCount)개 색상 로드됨")
} else {
    print("에러: \(ColorKit.setupError ?? "알 수 없음")")
}
```

---

## 마이그레이션 가이드

### 하드코딩 색상에서

이전:
```swift
Text("Hello")
    .foregroundColor(Color(red: 0, green: 0.478, blue: 1))
```

이후:
```swift
Text("Hello")
    .foregroundColor(Colors.brandPrimary.color)
```

### Asset Catalog에서

이전:
```swift
Text("Hello")
    .foregroundColor(Color("BrandPrimary"))
```

이후:
```swift
Text("Hello")
    .foregroundColor(Colors.brandPrimary.color)
```

### 점진적 마이그레이션

전환 기간 동안 두 시스템 병행:

```swift
// 새 색상은 ColorKit
.foregroundColor(Colors.textHeading.color)

// 레거시 색상은 Asset Catalog
.background(Color("LegacyBackground"))
```

---

## SwiftUI 예제

### 기본 뷰

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("제목")
                .foregroundColor(Colors.textHeading.color)

            Text("본문 텍스트")
                .foregroundColor(Colors.textBody.color)

            Button("액션") { }
                .foregroundColor(.white)
                .padding()
                .background(Colors.brandPrimary.color)
                .cornerRadius(8)
        }
        .padding()
        .background(Colors.backgroundMain.color)
    }
}
```

### 카드 컴포넌트

```swift
struct CardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("카드 제목")
                .foregroundColor(Colors.Text.heading.color)

            Text("카드 내용")
                .foregroundColor(Colors.Text.body.color)
        }
        .padding()
        .background(Colors.Background.card.color)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Colors.Border.light.color, lineWidth: 1)
        )
    }
}
```

---

## UIKit 예제

### 뷰 컨트롤러

```swift
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundMain.uiColor

        let label = UILabel()
        label.text = "Hello"
        label.textColor = Colors.textHeading.uiColor

        let button = UIButton()
        button.setTitle("액션", for: .normal)
        button.backgroundColor = Colors.brandPrimary.uiColor
        button.layer.cornerRadius = 8
    }
}
```

---

## 문제 해결

### 색상이 로드되지 않음

1. JSON 파일이 앱 번들에 있는지 확인
2. 파일명이 `configure()` 파라미터와 일치하는지 확인
3. `ColorKit.validateSetup()` 호출하여 진단

### 다크 모드가 작동하지 않음

1. 파일명 확인: `name-light.json` / `name-dark.json`
2. 두 파일이 번들에 있는지 확인
3. 두 파일의 키가 일치하는지 확인

### 빌드 플러그인이 생성되지 않음

1. ColorKitPlugin이 타겟에 할당되었는지 확인
2. 토큰 파일이 `Resources/design-tokens/`에 있는지 확인
3. 빌드 폴더 정리 후 재빌드

---

[← README로 돌아가기](../README.md)
