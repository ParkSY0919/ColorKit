# ColorKit 데모 앱 가이드

[English](DEMO_EN.md)

데모 앱을 통해 ColorKit 기능 학습.

---

## 목차

1. [개요](#개요)
2. [데모 실행](#데모-실행)
3. [데모 화면](#데모-화면)
4. [기능 테스트](#기능-테스트)
5. [콘솔 출력](#콘솔-출력)
6. [FAQ](#faq)

---

## 개요

데모 앱은 세 개의 화면으로 ColorKit 기능을 보여줌:

| 화면 | 목적 |
|------|------|
| JSON 컬러 테스트 | 기본 JSON 기반 색상 시스템 |
| Adaptive 컬러 테스트 | 라이트/다크 모드 전환 |
| Assets 컬러 테스트 | Xcode Assets와 비교 |

---

## 데모 실행

### 방법 1: 저장소에서

```bash
git clone https://github.com/ParkSY0919/ColorKit.git
cd ColorKit/ColorKit-Demo
open ColorKitDemo.xcodeproj
```

빌드 및 실행 (⌘R).

### 방법 2: 패키지에서

저장소 클론 시 `ColorKit-Demo/` 폴더에 포함.

### 요구사항

- Xcode 15.0+
- iOS 14.0+ 시뮬레이터 또는 기기

---

## 데모 화면

### 1. JSON 컬러 테스트 (ContentView)

JSON에서 색상 로드 테스트.

**확인 항목:**
- `colors.json`에서 로드된 색상
- 프로퍼티 접근: `Colors.brandPrimary.color`
- 생성된 Swift 확장 코드

**데모 코드 예시:**

```swift
Text("제목")
    .foregroundColor(Colors.textHeading.color)

Button("액션") { }
    .background(Colors.brandPrimary.color)
```

**사용된 JSON 구조:**

```json
{
  "brand-primary": "#007AFF",
  "background-main": "#FFFFFF",
  "text-heading": "#000000"
}
```

### 2. Adaptive 컬러 테스트 (AdaptiveColorTestView)

라이트/다크 모드 자동 전환 테스트.

**확인 항목:**
- 시스템 테마에 따른 색상 변경
- 앱 내 다크 모드 토글
- 실시간 색상 전환

**데모 코드 예시:**

```swift
// 동일 코드, 테마별 다른 색상
Colors.backgroundMain.color  // 라이트: #FFFFFF, 다크: #000000
Colors.textHeading.color     // 라이트: #000000, 다크: #FFFFFF
```

**사용된 JSON 구조:**

```json
{
  "background-main": {
    "light": "#FFFFFF",
    "dark": "#000000"
  }
}
```

### 3. Assets 컬러 테스트 (XcassetsColorTestView)

ColorKit과 Xcode Asset Catalog 비교.

**확인 항목:**
- 나란히 비교
- ColorKit vs Assets.xcassets vs 시스템 색상
- 마이그레이션 예시

**코드 비교:**

```swift
// ColorKit
Colors.accentPrimary.color

// Asset Catalog
Color("BrandPrimary")

// 시스템
.accentColor
```

---

## 기능 테스트

### 색상 자동 탐색

앱 실행 시 콘솔 확인:

```
✅ ColorKit: Auto-discovered 19 colors from 'colors.json'
```

### 다크 모드 토글

1. Adaptive 컬러 테스트 화면 이동
2. 토글로 테마 전환
3. 색상 변화 관찰

또는 시스템 설정 사용:
- iOS: 설정 → 디스플레이 및 밝기
- 시뮬레이터: Features → Toggle Appearance (⇧⌘A)

### 폴백 시스템

데모에는 폴백을 보여주기 위한 미정의 색상 포함:

```swift
Colors.futureColor.color        // 회색 표시
Colors.shadowColor.color        // 회색 표시 (미정의 시)
```

콘솔 출력:
```
⚠️ ColorKit: Color 'futureColor' not found. Using fallback.
```

### 코드 생성

각 화면에서 프로젝트에 복사할 수 있는 Swift 코드 표시:

```swift
extension Colors {
    public static var brandPrimary: DynamicColorProperty {
        return DynamicColorProperty(propertyName: "brandPrimary")
    }
}
```

---

## 콘솔 출력

### 성공적 로드

```
✅ ColorKit: Auto-discovered 19 colors from 'colors.json'
```

### 검증 출력

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

### 폴백 경고

```
⚠️ ColorKit: Color 'futureColor' not found. Using fallback.
⚠️ ColorKit: Color 'shadowColor' not found. Using fallback.
```

이 경고들은 폴백 시스템을 보여주기 위해 데모에서 의도적으로 발생.

---

## FAQ

### Q: "Color not found" 경고가 나타납니다. 에러인가요?

아니요. ColorKit의 폴백 시스템이 정상 작동하는 것입니다. 미정의 색상은 크래시 대신 회색으로 표시됩니다. 데모에는 이를 보여주기 위해 의도적으로 미정의 색상(`futureColor` 등)이 포함되어 있습니다.

### Q: JSON 수정 후 색상이 업데이트되지 않습니다

앱을 완전히 종료(⌘Q)하고 재시작하세요. ColorKit은 앱 시작 시 JSON을 로드합니다.

### Q: 어떤 JSON 파일을 사용해야 하나요?

- **단일 색상** (`colors.json`): 간단한 앱, 고정 브랜드 색상
- **적응형 색상** (`colors-adaptive.json`): 다크 모드 지원 앱

### Q: 폴백 경고를 어떻게 해결하나요?

1. 단일 JSON에서 적응형 JSON으로 전환
2. 또는 JSON 파일에 누락된 색상 추가

### Q: 데모 코드를 프로젝트에 복사해도 되나요?

네. 데모에 표시된 생성 코드를 프로젝트에 직접 복사할 수 있습니다.

---

## 프로젝트 구조

```
ColorKit-Demo/
├── ColorKitDemo/
│   ├── ColorKit_TestApp.swift      # 앱 진입점
│   ├── ContentView.swift           # JSON 컬러 테스트
│   ├── AdaptiveColorTestView.swift # Adaptive 컬러 테스트
│   ├── XcassetsColorTestView.swift # Assets 컬러 테스트
│   └── CodeGenerationTestView.swift
├── Resources/
│   ├── colors.json                 # 단일 색상 JSON
│   └── colors-adaptive.json        # 적응형 색상 JSON
└── Assets.xcassets/                # 비교용 Asset Catalog
```

---

## 데모 활용

### 개발자용

- 통합 전 ColorKit 테스트
- 색상 조합 실험
- 성능 검증

### 디자이너용

- 색상 시스템 구현 검토
- 다크 모드 외관 확인
- 접근성 검증

### QA용

- 기능 테스트
- 테마 전환 테스트
- 회귀 테스트

---

[← README로 돌아가기](../README.md)
