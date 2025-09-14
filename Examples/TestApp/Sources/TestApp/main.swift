import Foundation
import ColorKit

print("🧪 ColorKit 통합 테스트")
print(String(repeating: "=", count: 40))

// 1. ColorKit 초기화 확인
print("\n1️⃣ ColorKit 설정 검증:")
ColorKit.validateSetup()

// 2. 사용 가능한 색상 확인
print("\n2️⃣ 색상 개수: \(ColorKit.colorCount)개")

// 3. 몇 가지 색상 테스트
let testColors: [Colors] = [.background_primary, .brand_primary, .text_primary, .status_success]

print("\n3️⃣ 주요 색상 테마:")
for color in testColors {
    if let theme = ColorKit.theme(for: color) {
        print("   \(color.rawValue):")
        print("     Light: \(theme.light)")
        print("     Dark:  \(theme.dark)")
    }
}

// 4. UIKit 색상 생성 테스트
#if canImport(UIKit)
import UIKit
print("\n4️⃣ UIKit 색상 생성:")
let uiColor = Colors.brand_primary.uiColor
print("   brand_primary UIColor: ✅ 생성됨")
#endif

// 5. SwiftUI 색상 생성 테스트
#if canImport(SwiftUI)
import SwiftUI
print("\n5️⃣ SwiftUI 색상 생성:")
if #available(macOS 10.15, iOS 13.0, *) {
    let _ = Colors.background_primary.color
    print("   background_primary Color: ✅ 생성됨")
}
#endif

print("\n✅ 모든 테스트 통과!")
print("ColorKit이 성공적으로 작동합니다! 🎉")