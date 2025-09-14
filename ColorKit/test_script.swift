#!/usr/bin/env swift

// 이 스크립트는 ColorKit 프로젝트 내에서만 실행됩니다.
// 사용법: swift test_script.swift

import Foundation

print("🧪 ColorKit 간단 테스트 스크립트")
print("=================================")
print()
print("이 스크립트는 개발 중 빠른 테스트용입니다.")
print("실제 ColorKit 기능을 테스트하려면:")
print()
print("1. swift test              # 유닛 테스트 실행")  
print("2. cd Examples/TestApp && swift run  # 통합 테스트")
print("3. Xcode로 iOS 프로젝트 생성 후 ColorKit 추가")
print()

// ColorKit 없이 기본적인 검증
print("현재 프로젝트 상태:")
print("- Resources/design-tokens/ 폴더 존재:", FileManager.default.fileExists(atPath: "Resources/design-tokens"))
print("- light.tokens.json 존재:", FileManager.default.fileExists(atPath: "Resources/design-tokens/light.tokens.json"))
print("- dark.tokens.json 존재:", FileManager.default.fileExists(atPath: "Resources/design-tokens/dark.tokens.json"))
print("- primitive.tokens.json 존재:", FileManager.default.fileExists(atPath: "Resources/design-tokens/primitive.tokens.json"))

print()
print("ColorKit 라이브러리를 실제로 테스트하려면:")
print("swift test 또는 cd Examples/TestApp && swift run 을 실행하세요!")

print()