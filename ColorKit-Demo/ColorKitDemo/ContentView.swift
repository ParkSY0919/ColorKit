//
//  ContentView.swift
//  ColorKit-Test
//
//  Created by 박신영 on 9/27/25.
//

import SwiftUI
import ColorKit

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SingleColorTestView()
                .tabItem {
                    Image(systemName: "paintbrush")
                    Text("단일 컬러")
                }
                .tag(0)
            
            AdaptiveColorTestView()
                .tabItem {
                    Image(systemName: "moon.circle")
                    Text("Light/Dark")
                }
                .tag(1)
            
            XcassetsColorTestView()
                .tabItem {
                    Image(systemName: "folder.circle")
                    Text("Assets")
                }
                .tag(2)
            
            CodeGenerationTestView()
                .tabItem {
                    Image(systemName: "swift")
                    Text("코드 생성")
                }
                .tag(3)
            
        }
    }
}

struct SingleColorTestView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("ColorKit 단일 컬러 테스트")
                    .font(.title)
                    .foregroundColor(Colors.textHeading.color)
                
                // 배경 컬러 테스트
                VStack(spacing: 15) {
                    Text("배경 컬러")
                        .font(.headline)
                        .foregroundColor(Colors.textHeading.color)
                    
                    HStack(spacing: 10) {
                        ColorTestBox(colorName: "Main BG", color: Colors.backgroundMain.color)
                        ColorTestBox(colorName: "Secondary BG", color: Colors.backgroundSecondary.color)
                        ColorTestBox(colorName: "Card BG", color: Colors.backgroundCard.color)
                    }
                }
                
                // 텍스트 컬러 테스트
                VStack(spacing: 15) {
                    Text("텍스트 컬러")
                        .font(.headline)
                        .foregroundColor(Colors["text-heading"]?.swiftUIColor ?? Color.black)
                    
                    HStack(spacing: 10) {
                        ColorTestBox(colorName: "Heading", color: Colors["text-heading"]?.swiftUIColor ?? Color.black)
                        ColorTestBox(colorName: "Body", color: Colors["text-body"]?.swiftUIColor ?? Color.black)
                        ColorTestBox(colorName: "Caption", color: Colors["text-caption"]?.swiftUIColor ?? Color.black)
                        ColorTestBox(colorName: "Inverse", color: Colors["text-inverse"]?.swiftUIColor ?? Color.black)
                    }
                }
                
                // 브랜드 컬러 테스트
                VStack(spacing: 15) {
                    Text("브랜드 컬러")
                        .font(.headline)
                        .foregroundColor(Colors["text-heading"]?.swiftUIColor ?? Color.black)
                    
                    HStack(spacing: 10) {
                        ColorTestBox(colorName: "Brand Primary", color: Colors["brand-primary"]?.swiftUIColor ?? Color.blue)
                        ColorTestBox(colorName: "Brand Secondary", color: Colors["brand-secondary"]?.swiftUIColor ?? Color.blue)
                        ColorTestBox(colorName: "Brand Tertiary", color: Colors["brand-tertiary"]?.swiftUIColor ?? Color.purple)
                    }
                }
                
                // 상태 컬러 테스트
                VStack(spacing: 15) {
                    Text("상태 컬러")
                        .font(.headline)
                        .foregroundColor(Colors.textHeading.color)
                    
                    HStack(spacing: 10) {
                        ColorTestBox(colorName: "Success", color: Colors.stateSuccess.color)
                        ColorTestBox(colorName: "Warning", color: Colors.stateWarning.color)
                        ColorTestBox(colorName: "Error", color: Colors.stateError.color)
                        ColorTestBox(colorName: "Info", color: Colors.stateInfo.color)
                    }
                }
                
                // 경계선 컬러 테스트
                VStack(spacing: 15) {
                    Text("경계선 컬러")
                        .font(.headline)
                        .foregroundColor(Colors["text-heading"]?.swiftUIColor ?? Color.black)
                    
                    HStack(spacing: 10) {
                        ColorTestBox(colorName: "Light Border", color: Colors["border-light"]?.swiftUIColor ?? Color.gray)
                        ColorTestBox(colorName: "Medium Border", color: Colors["border-medium"]?.swiftUIColor ?? Color.gray)
                        ColorTestBox(colorName: "Strong Border", color: Colors["border-strong"]?.swiftUIColor ?? Color.gray)
                    }
                }
                
                // 액센트 컬러 테스트
                VStack(spacing: 15) {
                    Text("액센트 컬러")
                        .font(.headline)
                        .foregroundColor(Colors["text-heading"]?.swiftUIColor ?? Color.black)
                    
                    HStack(spacing: 10) {
                        ColorTestBox(colorName: "Accent Primary", color: Colors["accent-primary"]?.swiftUIColor ?? Color.blue)
                        ColorTestBox(colorName: "Accent Secondary", color: Colors["accent-secondary"]?.swiftUIColor ?? Color.blue)
                    }
                    
                    Button("테스트 버튼") {
                        print("Button tapped")
                    }
                    .foregroundColor(Colors.textInverse.color)
                    .padding()
                    .background(Colors.accentPrimary.color)
                    .cornerRadius(8)
                }
                
                // 존재하지 않는 컬러 테스트 (fallback 확인)
                VStack(spacing: 15) {
                    Text("Fallback 테스트")
                        .font(.headline)
                        .foregroundColor(Colors.textHeading.color)
                    
                    Text("존재하지 않는 컬러는 자동으로 회색으로 표시됩니다")
                        .font(.caption)
                        .foregroundColor(Colors.textCaption.color)
                    
                    ColorTestBox(colorName: "Non-existent Color", color: Colors["non-existent-color"]?.swiftUIColor ?? Color.gray)
                }
                
                // 동적 접근 방식 테스트
                VStack(spacing: 15) {
                    Text("동적 접근 테스트")
                        .font(.headline)
                        .foregroundColor(Colors["text-heading"]?.swiftUIColor ?? Color.black)
                    
                    Text("문자열로 컬러에 접근하는 방식")
                        .font(.caption)
                        .foregroundColor(Colors.textCaption.color)
                    
                    HStack(spacing: 10) {
                        ColorTestBox(colorName: "Dynamic Brand", color: Colors["brand-primary"]?.swiftUIColor ?? Color.black)
                        ColorTestBox(colorName: "Dynamic State", color: Colors["state-success"]?.swiftUIColor ?? Color.black)
                        ColorTestBox(colorName: "Dynamic Unknown", color: Colors["unknown-color"]?.swiftUIColor ?? Color.black)
                    }
                }
            }
            .padding()
        }
        .background(Colors.backgroundMain.color)
    }
}

struct ColorTestBox: View {
    let colorName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Rectangle()
                .fill(color)
                .frame(width: 80, height: 60)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Colors.borderLight.color, lineWidth: 1)
                )
            
            Text(colorName)
                .font(.caption)
                .foregroundColor(Colors.textCaption.color)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    ContentView()
}
