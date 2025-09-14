import SwiftUI
import ColorKit

struct ContentView: View {
    @State private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HeaderView()
                    
                    // Color Showcase
                    ColorShowcaseView()
                    
                    // Buttons
                    ButtonExamplesView()
                    
                    // Status Colors
                    StatusColorsView()
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .background(Colors.background_primary.color)
            .navigationTitle("ColorKit Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("다크모드 토글") {
                        isDarkMode.toggle()
                    }
                    .foregroundColor(Colors.brand_primary.color)
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            // ColorKit 설정 검증
            ColorKit.validateSetup()
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("🎨 ColorKit")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Colors.text_primary.color)
            
            Text("Figma 디자인 토큰에서 자동 생성된 색상들")
                .font(.body)
                .foregroundColor(Colors.text_secondary.color)
                .multilineTextAlignment(.center)
            
            Text("총 \(ColorKit.colorCount)개의 색상이 로드됨")
                .font(.caption)
                .foregroundColor(Colors.text_tertiary.color)
        }
        .padding()
        .background(Colors.background_secondary.color)
        .cornerRadius(12)
    }
}

struct ColorShowcaseView: View {
    let showcaseColors: [(String, Colors)] = [
        ("배경 기본", .background_primary),
        ("브랜드 기본", .brand_primary),
        ("텍스트 기본", .text_primary),
        ("성공", .status_success),
        ("오류", .status_error),
        ("경고", .status_warning)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("색상 팔레트")
                .font(.headline)
                .foregroundColor(Colors.text_primary.color)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(showcaseColors, id: \.0) { name, color in
                    ColorCard(name: name, color: color)
                }
            }
        }
    }
}

struct ColorCard: View {
    let name: String
    let color: Colors
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.color)
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Colors.border_default.color, lineWidth: 1)
                )
            
            Text(name)
                .font(.caption)
                .foregroundColor(Colors.text_secondary.color)
            
            if let theme = ColorKit.theme(for: color) {
                VStack(spacing: 2) {
                    Text("L: \(theme.light)")
                        .font(.system(size: 8, family: .monospaced))
                    Text("D: \(theme.dark)")
                        .font(.system(size: 8, family: .monospaced))
                }
                .foregroundColor(Colors.text_tertiary.color)
            }
        }
        .padding(8)
        .background(Colors.background_secondary.color)
        .cornerRadius(8)
    }
}

struct ButtonExamplesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("버튼 예제")
                .font(.headline)
                .foregroundColor(Colors.text_primary.color)
            
            VStack(spacing: 12) {
                Button("주요 액션") {
                    print("주요 버튼 클릭됨")
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("보조 액션") {
                    print("보조 버튼 클릭됨")
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("링크 액션") {
                    print("링크 버튼 클릭됨")
                }
                .buttonStyle(LinkButtonStyle())
            }
        }
    }
}

struct StatusColorsView: View {
    let statusItems = [
        ("성공", Colors.status_success, "checkmark.circle.fill"),
        ("오류", Colors.status_error, "xmark.circle.fill"),
        ("경고", Colors.status_warning, "exclamationmark.triangle.fill"),
        ("정보", Colors.status_info, "info.circle.fill")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("상태 색상")
                .font(.headline)
                .foregroundColor(Colors.text_primary.color)
            
            VStack(spacing: 8) {
                ForEach(statusItems, id: \.0) { name, color, icon in
                    HStack {
                        Image(systemName: icon)
                            .foregroundColor(color.color)
                        
                        Text(name)
                            .foregroundColor(Colors.text_primary.color)
                        
                        Spacer()
                        
                        if let theme = ColorKit.theme(for: color) {
                            Text(theme.light)
                                .font(.caption.monospaced())
                                .foregroundColor(Colors.text_tertiary.color)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Colors.background_secondary.color)
                    .cornerRadius(8)
                }
            }
        }
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Colors.text_inverse.color)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Colors.brand_primary.color)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Colors.brand_primary.color)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Colors.background_tertiary.color)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Colors.border_default.color, lineWidth: 1)
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Colors.brand_primary.color)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    ContentView()
}