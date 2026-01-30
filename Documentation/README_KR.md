# ColorKit

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2014+%20%7C%20macOS%2011+-blue.svg)](https://developer.apple.com/swift/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](../LICENSE)

[English](../README.md)

JSON 디자인 토큰을 Swift 색상으로. 설정 없이 바로 사용.

## 기능

- JSON 파일에서 색상 자동 탐색
- 라이트/다크 모드 자동 전환
- 다양한 접근 방식 (프로퍼티, 서브스크립트, 네임스페이스)
- 누락된 색상 폴백 시스템
- SwiftUI, UIKit 지원
- Figma 토큰 호환

## 설치

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/ParkSY0919/ColorKit.git", from: "0.2.0")
]
```

### Xcode

1. File → Add Package Dependencies
2. `https://github.com/ParkSY0919/ColorKit.git` 입력
3. **ColorKit**과 **ColorKitPlugin** 모두 타겟에 할당

## 빠른 시작

**1. JSON 파일 추가**

`colors.json` 파일을 생성하고 Xcode 프로젝트에 추가:
- 파일을 Xcode로 드래그
- "Copy items if needed" 체크
- "Add to targets"에서 앱 타겟 체크

```json
{
  "brand-primary": "#007AFF",
  "background-main": "#FFFFFF",
  "text-heading": "#1D1D1F"
}
```

**2. 앱 시작 시 설정**

`configure()`에 파일명 전달 (`.json` 확장자 제외):

```swift
import ColorKit

@main
struct MyApp: App {
    init() {
        ColorKit.configure(jsonFileName: "colors")  // colors.json 로드
    }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

**3. 색상 사용**

```swift
Text("Hello")
    .foregroundColor(Colors.textHeading.color)
    .background(Colors.backgroundMain.color)
```

## 다크 모드

`-light`, `-dark` 접미사로 파일 분리:

```
colors-light.json
colors-dark.json
```

시스템 테마에 따라 자동 전환.

## 접근 방식

```swift
// 프로퍼티 접근 (권장)
Colors.brandPrimary.color

// 서브스크립트로 정확한 키 접근
Colors["brand-primary"]?.color ?? .blue

// 네임스페이스 접근
Colors.Brand.primary.color
Colors.Background.main.color
```

## 문서

- [상세 가이드](GUIDE.md) - API 레퍼런스, 설정 옵션
- [데모 앱 가이드](DEMO_KR.md) - 데모 실행 및 탐색

## 요구사항

- iOS 14.0+ / macOS 11.0+
- Swift 5.9+
- Xcode 15.0+

## 라이선스

MIT License. [LICENSE](../LICENSE) 참조.

---

[← README로 돌아가기](../README.md)
