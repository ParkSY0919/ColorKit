//
//  ColorKit_TestApp.swift
//  ColorKit-Test
//
//  Created by 박신영 on 9/27/25.
//

import SwiftUI
import ColorKit

@main
struct ColorKit_TestApp: App {
    
    init() {
        // ColorKit 설정 - 단일 컬러 모드
        ColorKit.configure(jsonFileName: "colors")
        
        // 자동 생성된 코드 출력 (개발용)
        #if DEBUG
        ColorKit.printGeneratedExtensions()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
