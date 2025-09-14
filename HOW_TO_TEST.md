# ColorKit 테스트 가이드

ColorKit을 테스트하고 실제 사용하는 방법들을 설명합니다.

## 🧪 개발자 테스트 (ColorKit 프로젝트 내에서)

### 1. 유닛 테스트 실행
```bash
cd /Users/Git/ColorKit/ColorKit
swift test
```

### 2. 통합 테스트 실행
```bash
cd Examples/TestApp
swift run
```

### 3. 간단한 상태 체크
```bash
swift test_script.swift
```

## 📱 실제 iOS 앱에서 테스트 방법

### 방법 1: Xcode 프로젝트 생성

1. **새 iOS 프로젝트 생성**
   - Xcode > Create a new Xcode project > iOS App
   - SwiftUI 선택

2. **ColorKit 의존성 추가**
   - File > Add Package Dependencies
   - 로컬 경로 입력: `file:///Users/Git/ColorKit/ColorKit`
   - 또는 GitHub URL: `https://github.com/ParkSY0919/ColorKit.git`

3. **design-tokens 폴더 추가**
   ```
   YourApp/
   ├── Sources/
   │   └── YourApp/
   │       ├── ContentView.swift
   │       └── Resources/
   │           └── design-tokens/     # ← 이 폴더 추가
   │               ├── light.tokens.json
   │               ├── dark.tokens.json
   │               └── primitive.tokens.json
   ```

4. **ColorKit 사용**
   ```swift
   import SwiftUI
   import ColorKit

   struct ContentView: View {
       var body: some View {
           VStack {
               Text("Hello ColorKit!")
                   .foregroundColor(Colors.text_primary.color)
               
               Button("Test Button") {
                   ColorKit.validateSetup()
               }
               .foregroundColor(Colors.text_inverse.color)
               .padding()
               .background(Colors.brand_primary.color)
               .cornerRadius(8)
           }
           .padding()
           .background(Colors.background_primary.color)
           .onAppear {
               ColorKit.validateSetup()
           }
       }
   }
   ```

### 방법 2: 제공된 Demo 사용

1. **Demo 파일 복사**
   ```bash
   # ColorKit/Examples/iOS-Demo/ 폴더의 내용을 새 프로젝트에 복사
   cp Examples/iOS-Demo/* YourNewProject/Sources/YourNewProject/
   ```

2. **실행**
   - Xcode에서 프로젝트 열기
   - 시뮬레이터에서 실행
   - 다크모드 토글 테스트

## 🎨 다양한 테스트 시나리오

### 1. 기본 색상 테스트
```swift
import ColorKit

// 설정 검증
ColorKit.validateSetup()

// 색상 개수 확인
print("로드된 색상: \(ColorKit.colorCount)개")

// 특정 색상 테마 확인
if let theme = ColorKit.theme(for: .brand_primary) {
    print("브랜드 색상 - Light: \(theme.light), Dark: \(theme.dark)")
}
```

### 2. UIKit에서 테스트
```swift
import UIKit
import ColorKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경색 설정
        view.backgroundColor = Colors.background_primary.uiColor
        
        // 버튼 생성
        let button = UIButton()
        button.backgroundColor = Colors.brand_primary.uiColor
        button.setTitle("ColorKit 버튼", for: .normal)
        button.setTitleColor(Colors.text_inverse.uiColor, for: .normal)
    }
}
```

### 3. SwiftUI에서 테스트
```swift
import SwiftUI
import ColorKit

struct TestView: View {
    @State private var isDark = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ColorKit 테스트")
                .font(.title)
                .foregroundColor(Colors.text_primary.color)
            
            // 색상 카드들
            HStack {
                ForEach([Colors.brand_primary, .status_success, .status_error], id: \.rawValue) { color in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.color)
                        .frame(width: 60, height: 60)
                }
            }
            
            Button("다크모드 토글") {
                isDark.toggle()
            }
            .foregroundColor(Colors.brand_primary.color)
        }
        .padding()
        .background(Colors.background_primary.color)
        .preferredColorScheme(isDark ? .dark : .light)
    }
}
```

## 🔧 자신만의 디자인 토큰으로 테스트

### 1. JSON 파일 수정
`Resources/design-tokens/` 폴더의 JSON 파일들을 수정하여 자신만의 색상을 테스트할 수 있습니다:

```json
// light.tokens.json
{
  "Brand": {
    "primary": {
      "$type": "color",
      "$value": "#FF6B35"  // 원하는 색상으로 변경
    }
  },
  "Background": {
    "primary": {
      "$type": "color", 
      "$value": "#FFFFFF"
    }
  }
}
```

### 2. 빌드 후 확인
JSON 파일을 수정한 후:
1. 프로젝트 클린 빌드 (`Product > Clean Build Folder`)
2. 다시 빌드
3. 새로운 색상 확인

## 📊 생성된 색상 확인 방법

### 1. 콘솔에서 확인
```swift
ColorKit.validateSetup()  // 콘솔에 색상 정보 출력
```

### 2. 모든 색상 나열
```swift
for (name, theme) in ColorKit.allThemes {
    print("\(name): Light=\(theme.light), Dark=\(theme.dark)")
}
```

### 3. 생성된 파일 직접 확인
빌드 후 생성된 파일들을 직접 볼 수 있습니다:
```bash
# 생성된 Colors.swift 확인
find .build -name "Colors.swift" -exec cat {} \;

# 생성된 ColorThemes.swift 확인  
find .build -name "ColorThemes.swift" -exec cat {} \;
```

## ⚠️ 문제 해결

### 색상이 로드되지 않을 때
1. `ColorKit.validateSetup()` 호출하여 에러 메시지 확인
2. JSON 파일 경로가 올바른지 확인: `Resources/design-tokens/`
3. JSON 파일 형식이 올바른지 확인
4. 프로젝트 클린 빌드 후 다시 시도

### 빌드 에러 발생 시
1. Xcode에서 Product > Clean Build Folder
2. JSON 파일 syntax 확인
3. 필수 JSON 파일들이 모두 있는지 확인

## 🎯 권장 테스트 순서

1. **swift test** - 기본 동작 확인
2. **Examples/TestApp** - 통합 테스트
3. **새 Xcode 프로젝트** - 실제 사용 시나리오
4. **자신의 JSON** - 커스텀 색상 테스트

이렇게 하면 ColorKit의 모든 기능을 체계적으로 테스트할 수 있습니다!