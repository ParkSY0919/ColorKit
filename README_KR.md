# ColorKit 🎨

[![Swift 5.5+](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![iOS 13+](https://img.shields.io/badge/iOS-13+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 11+](https://img.shields.io/badge/macOS-11+-blue.svg)](https://developer.apple.com/macos/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**ColorKit**은 JSON 디자인 토큰으로부터 자동으로 색상을 탐지하고 관리하는 강력하고 유연한 Swift 패키지입니다. 설정이 전혀 필요 없습니다 - JSON 파일만 추가하면 완전한 타입 안전성과 자동 다크 모드 지원으로 색상을 바로 사용할 수 있습니다.

[한국어 README](README_KR.md) | [English README](README.md)

---

## ✨ 주요 기능

- **🚀 제로 설정**: JSON 파일만 추가하면 끝 - 매핑 설정 불필요
- **🎯 다중 접근 패턴**: 프로퍼티 방식, 서브스크립트, 문자열 기반 접근
- **🌙 자동 다크 모드**: 라이트/다크 테마 자동 지원
- **📱 SwiftUI & UIKit**: 두 프레임워크 완전 지원
- **🔍 스마트 탐지**: 모든 JSON 색상 구조를 자동 발견 및 변환
- **⚡ 타입 안전성**: IDE 자동완성과 컴파일 타임 안전성
- **🎨 유연한 JSON 지원**: Figma 익스포트, 커스텀 토큰, 중첩 구조 지원

## 🚀 빠른 시작

### 1. ColorKit 설치

Swift Package Manager로 프로젝트에 ColorKit 추가:

```swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "1.0.0")
]
```

### 2. 색상 JSON 파일 추가

앱 번들에 JSON 파일 생성 (예: `Resources/app-colors.json`):

```json
{
  "brand-primary": "#007AFF",
  "brand-secondary": "#5856D6", 
  "text-heading": "#000000",
  "text-body": "#333333",
  "background-main": "#FFFFFF",
  "success-green": "#34C759",
  "error-red": "#FF3B30"
}
```

### 3. ColorKit 설정

App 파일이나 앱 생명주기 초기에:

```swift
import ColorKit

@main
struct MyApp: App {
    init() {
        ColorKit.configure(jsonFileName: "app-colors")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 4. 모든 곳에서 색상 사용

```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("환영합니다!")
                .foregroundColor(Colors.brandPrimary.color)
                .background(Colors.backgroundMain.color)
            
            Button("성공") {
                // 액션
            }
            .foregroundColor(Colors.successGreen.color)
        }
    }
}
```

## 🎯 다중 접근 패턴

ColorKit은 색상에 접근하는 4가지 방법을 제공합니다:

### 1. 프로퍼티 스타일 접근 (권장)
```swift
Colors.brandPrimary.color        // SwiftUI Color
Colors.brandPrimary.uiColor      // UIColor
Colors.textHeading.color
Colors.backgroundMain.color
```

### 2. 서브스크립트 접근
```swift
Colors["brand-primary"]?.color
Colors["text-heading"]?.uiColor
```

### 3. 문자열 기반 접근
```swift
Colors.color(named: "brand-primary")?.color
Colors.swiftUIColor(named: "success-green")
Colors.uiColor(named: "error-red")
```

### 4. 의미론적 그룹핑 (자동 생성)
```swift
Colors.Brand.main.color          // "app-brand-main"이 존재하면
Colors.Text.heading.color        // "app-text-heading"이 존재하면
Colors.State.success.color       // "app-state-success"가 존재하면
```

## 🎨 지원하는 JSON 구조

ColorKit은 다양한 JSON 색상 형태를 자동으로 처리합니다:

### 단순 키-값 구조
```json
{
  "primary": "#007AFF",
  "secondary": "#5856D6"
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

## 🌙 다크 모드 지원

ColorKit은 라이트 및 다크 테마를 자동으로 지원합니다:

### 자동 테마 JSON 구조
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

### 단일 색상 (라이트/다크 동일)
```json
{
  "brand-primary": "#007AFF"  // 라이트/다크 동일 색상
}
```

색상은 현재 인터페이스 스타일에 자동으로 적응합니다:

```swift
// 현재 테마에 맞는 올바른 색상을 자동으로 표시
Text("안녕하세요")
    .foregroundColor(Colors.textPrimary.color)
```

## 🔧 고급 사용법

### 색상 탐지 및 내부 검사

```swift
// 사용 가능한 모든 색상 가져오기
let allColors = Colors.allColorNames
print("사용 가능한 색상: \(allColors)")

// 색상 검색
let brandColors = Colors.searchColors(containing: "brand")
print("브랜드 색상들: \(brandColors)")

// 카테고리별 색상 가져오기
let colorsByCategory = Colors.colorsByCategory
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
                .foregroundColor(Colors.textHeading.color)
                .font(.title)
            
            Text("부제목") 
                .foregroundColor(Colors.textBody.color)
                .font(.body)
                
            Button("액션") {
                // 액션 처리
            }
            .foregroundColor(.white)
            .background(Colors.brandPrimary.color)
            .cornerRadius(8)
        }
        .padding()
        .background(Colors.backgroundMain.color)
    }
}
```

### UIKit 예시
```swift
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.backgroundMain.uiColor
        
        let titleLabel = UILabel()
        titleLabel.textColor = Colors.textHeading.uiColor
        titleLabel.text = "환영합니다"
        
        let button = UIButton()
        button.setTitleColor(.white, for: .normal) 
        button.backgroundColor = Colors.brandPrimary.uiColor
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

- iOS 13.0+ / macOS 11.0+
- Swift 5.5+
- Xcode 13.0+

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

## 🙋‍♂️ 지원

- 📖 [문서](https://github.com/ParkSY0919/ColorKit/wiki)
- 🐛 [이슈 트래커](https://github.com/ParkSY0919/ColorKit/issues)
- 💬 [토론](https://github.com/ParkSY0919/ColorKit/discussions)

---

❤️를 담아 [ParkSY0919](https://github.com/ParkSY0919)가 만들었습니다