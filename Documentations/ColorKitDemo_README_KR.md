# ColorKit Demo App Guide

ColorKit을 처음 사용하는 개발자들을 위한 종합 가이드입니다. 이 데모 앱을 통해 ColorKit의 모든 기능을 체험하고 학습할 수 있습니다.

## 📱 데모 앱 개요

ColorKit Demo App은 다음 3가지 주요 화면으로 구성되어 있습니다:

1. **JSON 컬러 테스트** - JSON 기반 컬러 시스템
2. **Adaptive 컬러 테스트** - Light/Dark 모드 적응형 컬러
3. **Assets 컬러 테스트** - Xcode Assets.xcassets 컬러와의 비교

## 🎨 화면별 가이드

### 1. JSON 컬러 테스트 (ContentView)

**목적**: 기본적인 JSON 기반 컬러 시스템 사용법 학습

#### 주요 기능:
- **단일 컬러 로딩**: `colors.json` 파일에서 컬러 자동 발견
- **컬러 사용법**: `Colors.brandPrimary.color` 형태로 접근
- **실시간 코드 생성**: 발견된 컬러들의 Swift 확장 코드 자동 생성

#### 학습 포인트:
```swift
// 1. 기본 사용법
Colors.brandPrimary.color          // SwiftUI Color
Colors.brandPrimary.uiColor        // UIKit UIColor

// 2. 컬러 속성 접근
.background(Colors.backgroundMain.color)
.foregroundColor(Colors.textHeading.color)
```

#### JSON 파일 구조:
```json
{
  "brand-primary": "#007AFF",
  "background-main": "#FFFFFF",
  "text-heading": "#000000"
}
```

### 2. Adaptive 컬러 테스트 (AdaptiveColorTestView)

**목적**: Light/Dark 모드 적응형 컬러 시스템 마스터하기

#### 주요 기능:
- **적응형 컬러**: 라이트/다크 모드에 따른 자동 컬러 변경
- **실시간 모드 전환**: 앱 내에서 다크모드 토글 가능
- **코드 생성**: 적응형 컬러 확장 코드 자동 생성

#### 학습 포인트:
```swift
// 적응형 컬러 사용 (라이트/다크 자동 변경)
Colors.backgroundMain.color  // 라이트: #FFFFFF, 다크: #000000
Colors.textHeading.color     // 라이트: #000000, 다크: #FFFFFF
```

#### Adaptive JSON 구조:
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

### 3. Assets 컬러 테스트 (XcassetsColorTestView)

**목적**: 기존 Xcode Assets 컬러와 ColorKit 비교 학습

#### 주요 기능:
- **컬러 소스 비교**: JSON vs Assets vs 시스템 컬러 비교
- **실제 사용 사례**: 버튼, 카드, 배경 등 실용적 예제
- **Assets 호환성**: 기존 프로젝트 migration 방법 이해

#### 학습 포인트:
```swift
// 3가지 컬러 정의 방식 비교
Colors.accentPrimary.color    // JSON 기반 (ColorKit)
Color("BrandPrimary")         // Assets.xcassets
.accentColor                  // SwiftUI 시스템 컬러
```

## 🚀 시작하기

### 1. ColorKit 설치

**Swift Package Manager**:
```
https://github.com/ParkSY0919/ColorKit.git
```

**프로젝트에 추가**:
```swift
import ColorKit
```

### 2. JSON 컬러 파일 생성

프로젝트에 `colors.json` 파일을 추가하고 번들에 포함:

```json
{
  "primary": "#007AFF",
  "secondary": "#5AC8FA",
  "background": "#FFFFFF",
  "text": "#000000"
}
```

### 3. 기본 사용법

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

## 🎯 주요 기능 체험하기

### 1. 자동 컬러 발견
앱 실행 시 콘솔에서 확인:
```
✅ ColorKit: Auto-discovered 19 colors from 'colors.json'
```

### 2. 실시간 코드 생성
데모 앱에서 생성된 코드를 복사하여 프로젝트에 적용:
```swift
extension Colors {
    public static var primary: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "primary")
    }
}
```

### 3. 다크모드 지원
Adaptive 컬러 테스트에서 실시간으로 모드 전환 체험

### 4. 에러 처리 및 Fallback 시스템
존재하지 않는 컬러 사용 시 자동 fallback (회색으로 표시):
```
⚠️ ColorKit: Color 'futureColor' not found. Using fallback.
⚠️ ColorKit: Color 'shadowColor' not found. Using fallback.
⚠️ ColorKit: Color 'backgroundElevated' not found. Using fallback.
```

**Fallback 발생 원인:**
- **단일 컬러 JSON 사용 시**: `shadowColor`, `backgroundElevated` 등 일부 컬러가 정의되지 않은 경우
- **적응형 컬러(Adaptive Color) 전환 시**: 모든 컬러가 light/dark 정의를 가지고 있어 fallback 없이 동작

**해결 방법:**
1. **단일 컬러 → 적응형 컬러 전환**: `colors-adaptive.json` 사용
2. **누락된 컬러 추가**: 단일 컬러 JSON에 필요한 컬러 정의 추가

**데모 앱의 의도적 에러 예제들:**
- `futureColor`: 존재하지 않는 컬러로 fallback 동작 테스트용
- `shadowColor`: 단일 컬러 JSON에서 누락된 컬러 (적응형에서는 정의됨)
- `backgroundElevated`: 단일 컬러 JSON에서 누락된 컬러 (적응형에서는 정의됨)

이러한 예제들은 **실제 에러가 아니라** ColorKit의 안전한 fallback 시스템을 보여주는 교육용 코드입니다.

## 💡 실전 팁

### 1. 네이밍 규칙
- **용도 기반**: `background-main`, `text-heading`
- **계층 구조**: `brand-primary`, `brand-secondary`
- **상태별**: `state-success`, `state-error`

### 2. JSON vs Adaptive 선택
- **단순한 앱**: `colors.json` (단일 컬러)
- **다크모드 지원**: `colors-adaptive.json` (적응형)

### 3. 마이그레이션 전략
기존 Assets 컬러 → ColorKit으로 점진적 이전:
```swift
// 기존
Color("BrandPrimary")

// ColorKit으로 변경
Colors.brandPrimary.color
```

## 🔧 커스터마이징

### 1. 커스텀 컬러 추가
JSON 파일에 새 컬러 추가 후 앱 재시작:
```json
{
  "custom-accent": "#FF6B6B",
  "custom-background": "#F8F9FA"
}
```

### 2. 네임스페이스 변경
필요시 `Colors` 대신 다른 이름 사용 가능

### 3. 폴백 컬러 설정
존재하지 않는 컬러에 대한 기본값 설정 가능

## ⚠️ 주의사항 및 FAQ

### Q: 콘솔에 "Color not found" 경고가 나타나는데 에러인가요?
**A**: 아닙니다! 이는 ColorKit의 안전한 fallback 시스템입니다.
- 존재하지 않는 컬러 사용 시 회색으로 대체
- 앱이 크래시되지 않고 안전하게 동작
- 데모 앱의 `futureColor` 등은 의도적인 테스트 케이스

### Q: JSON 파일을 수정했는데 반영되지 않아요
**A**: 앱을 완전히 종료하고 재시작해주세요. ColorKit은 앱 시작 시 JSON을 로드합니다.

### Q: 단일 컬러와 적응형 컬러 중 어떤 것을 선택해야 하나요?
**A**:
- **단일 컬러**: 간단한 앱, 브랜드 컬러 고정이 필요한 경우 (일부 컬러 fallback 발생 가능)
- **적응형 컬러**: 다크모드 지원, 접근성 고려가 필요한 경우 (모든 컬러 정의되어 fallback 없음)

### Q: `shadowColor`, `backgroundElevated` fallback 경고를 해결하려면?
**A**: 단일 컬러 JSON에서 적응형 컬러 JSON으로 전환하면 해결됩니다.
- **현재**: `colors.json` (단일 컬러) → 일부 컬러 누락으로 fallback 발생
- **해결**: `colors-adaptive.json` (적응형 컬러) → 모든 컬러 light/dark 정의되어 fallback 없음

## 📚 추가 학습 자료

1. **ColorKit GitHub**: [https://github.com/ParkSY0919/ColorKit.git](https://github.com/ParkSY0919/ColorKit.git)
2. **SwiftUI Color 문서**: Apple Developer Documentation
3. **Design System 구축**: 컬러 시스템 디자인 가이드라인

## 🎨 데모 앱 활용법

### 개발자용
- 새 기능 테스트
- 컬러 조합 실험
- 성능 확인

### 디자이너용
- 컬러 시스템 검토
- 다크모드 확인
- 접근성 검증

### QA용
- 기능 테스트
- 회귀 테스트
- 사용성 검증

---

**문의사항이나 개선 제안은 GitHub Issues를 통해 제출해 주세요!** 🚀