#!/usr/bin/env swift

import Foundation
import ColorKit

print("🧪 ColorKit 테스트 시작\n")

// 1. 기본 설정 검증
print("1️⃣ ColorKit 설정 검증:")
ColorKit.validateSetup()

// 2. 색상 enum 테스트
print("\n2️⃣ Colors enum 테스트:")
print("   사용 가능한 색상 수: \(Colors.allCases.count)")
print("   첫 번째 색상: \(Colors.allCases.first?.rawValue ?? "없음")")
print("   마지막 색상: \(Colors.allCases.last?.rawValue ?? "없음")")

// 3. 색상 테마 접근 테스트
print("\n3️⃣ 색상 테마 접근 테스트:")
if let theme = ColorKit.theme(for: .background_primary) {
    print("   background_primary - Light: \(theme.light), Dark: \(theme.dark)")
} else {
    print("   ❌ background_primary 테마를 찾을 수 없음")
}

if let theme = ColorKit.theme(for: .brand_primary) {
    print("   brand_primary - Light: \(theme.light), Dark: \(theme.dark)")
} else {
    print("   ❌ brand_primary 테마를 찾을 수 없음")
}

// 4. UIColor 생성 테스트 
print("\n4️⃣ UIColor 생성 테스트:")
#if canImport(UIKit)
import UIKit
let uiColor = Colors.background_primary.uiColor
print("   ✅ UIColor 생성 성공: \(uiColor)")
#else
print("   ⚠️ UIKit을 사용할 수 없는 환경")
#endif

// 5. SwiftUI Color 생성 테스트
print("\n5️⃣ SwiftUI Color 생성 테스트:")
#if canImport(SwiftUI)
import SwiftUI
if #available(macOS 10.15, *) {
    let swiftUIColor = Colors.brand_primary.color
    print("   ✅ SwiftUI Color 생성 성공: \(swiftUIColor)")
} else {
    print("   ⚠️ SwiftUI를 사용할 수 없는 macOS 버전")
}
#else
print("   ⚠️ SwiftUI를 사용할 수 없는 환경")
#endif

// 6. 모든 색상 나열
print("\n6️⃣ 사용 가능한 모든 색상:")
for (index, color) in Colors.allCases.enumerated() {
    if let theme = ColorKit.theme(for: color) {
        print("   \(index + 1). \(color.rawValue) - Light: \(theme.light), Dark: \(theme.dark)")
    }
}

print("\n✅ 테스트 완료!")