import SwiftUI
import ColorKit

struct AdaptiveColorTestView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var currentConfigFile = "colors-adaptive"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 설정 스위처
                VStack(spacing: 10) {
                    Text("ColorKit Light/Dark 모드 테스트")
                        .font(.title)
                        .foregroundColor(Colors.textHeading.color)
                    
                    Button("Adaptive 모드로 전환") {
                        ColorKit.configure(jsonFileName: "colors-adaptive")
                        currentConfigFile = "colors-adaptive"
                    }
                    .foregroundColor(Colors.textInverse.color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Colors.brandPrimary.color)
                    .cornerRadius(8)
                }
                
                // 현재 모드 표시
                VStack(spacing: 8) {
                    HStack {
                        Text("현재 모드:")
                                .foregroundColor(Colors.textCaption.color)
                        Text(colorScheme == .dark ? "Dark" : "Light")
                            .foregroundColor(Colors["brand-primary"]?.swiftUIColor ?? Color.blue)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("설정 파일:")
                                .foregroundColor(Colors.textCaption.color)
                        Text(currentConfigFile)
                            .foregroundColor(Colors["text-body"]?.swiftUIColor ?? Color.black)
                            .fontWeight(.medium)
                    }
                }
                .padding()
                .background(Colors.backgroundCard.color)
                .cornerRadius(10)
                .shadow(color: Colors.shadowColor.color, radius: 2, x: 0, y: 1)
                
                // 배경 컬러 테스트
                AdaptiveColorSection(title: "배경 컬러") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        AdaptiveColorBox(colorName: "Main", color: Colors.backgroundMain.color)
                        AdaptiveColorBox(colorName: "Secondary", color: Colors.backgroundSecondary.color)
                        AdaptiveColorBox(colorName: "Card", color: Colors.backgroundCard.color)
                        AdaptiveColorBox(colorName: "Elevated", color: Colors.backgroundElevated.color)
                    }
                }
                
                // 텍스트 컬러 테스트
                AdaptiveColorSection(title: "텍스트 컬러") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        AdaptiveColorBox(colorName: "Heading", color: Colors["text-heading"]?.swiftUIColor ?? Color.black)
                        AdaptiveColorBox(colorName: "Body", color: Colors["text-body"]?.swiftUIColor ?? Color.black)
                        AdaptiveColorBox(colorName: "Caption", color: Colors["text-caption"]?.swiftUIColor ?? Color.gray)
                        AdaptiveColorBox(colorName: "Inverse", color: Colors["text-inverse"]?.swiftUIColor ?? Color.white)
                    }
                }
                
                // 브랜드 컬러 테스트
                AdaptiveColorSection(title: "브랜드 컬러") {
                    HStack(spacing: 15) {
                        AdaptiveColorBox(colorName: "Brand Primary", color: Colors["brand-primary"]?.swiftUIColor ?? Color.blue)
                        AdaptiveColorBox(colorName: "Brand Secondary", color: Colors["brand-secondary"]?.swiftUIColor ?? Color.blue)
                        AdaptiveColorBox(colorName: "Brand Tertiary", color: Colors["brand-tertiary"]?.swiftUIColor ?? Color.purple)
                    }
                }
                
                // 상태 컬러 테스트
                AdaptiveColorSection(title: "상태 컬러") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        AdaptiveColorBox(colorName: "Success", color: Colors.stateSuccess.color)
                        AdaptiveColorBox(colorName: "Warning", color: Colors.stateWarning.color)
                        AdaptiveColorBox(colorName: "Error", color: Colors.stateError.color)
                        AdaptiveColorBox(colorName: "Info", color: Colors.stateInfo.color)
                    }
                }
                
                // 경계선 & 액센트 컬러 테스트
                AdaptiveColorSection(title: "경계선 & 액센트") {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            AdaptiveColorBox(colorName: "Light Border", color: Colors["border-light"]?.swiftUIColor ?? Color.gray)
                            AdaptiveColorBox(colorName: "Medium Border", color: Colors["border-medium"]?.swiftUIColor ?? Color.gray)
                            AdaptiveColorBox(colorName: "Strong Border", color: Colors["border-strong"]?.swiftUIColor ?? Color.gray)
                        }
                        
                        HStack(spacing: 15) {
                            AdaptiveColorBox(colorName: "Accent Primary", color: Colors["accent-primary"]?.swiftUIColor ?? Color.blue)
                            AdaptiveColorBox(colorName: "Accent Secondary", color: Colors["accent-secondary"]?.swiftUIColor ?? Color.blue)
                        }
                        
                        // 버튼 테스트
                        Button("Adaptive 테스트 버튼") {
                            print("Adaptive button tapped in \(colorScheme) mode")
                        }
                        .foregroundColor(Colors["text-inverse"]?.swiftUIColor ?? Color.white)
                        .padding()
                        .background(Colors["accent-primary"]?.swiftUIColor ?? Color.blue)
                        .cornerRadius(8)
                        
                        // 구분선 테스트
                        Rectangle()
                            .fill(Colors.borderMedium.color)
                            .frame(height: 1)
                            .padding(.horizontal)
                    }
                }
                
                // 실제 UI 컴포넌트 예시
                AdaptiveColorSection(title: "실제 컴포넌트 예시") {
                    VStack(spacing: 15) {
                        // 카드 예시
                        VStack(alignment: .leading, spacing: 10) {
                            Text("샘플 카드")
                                .font(.headline)
                                .foregroundColor(Colors.textHeading.color)
                            
                            Text("이 카드는 Light/Dark 모드에 따라 배경색과 텍스트 색상이 자동으로 변경됩니다. ColorKit의 adaptive 설정을 통해 자동으로 테마가 적용됩니다.")
                                .font(.body)
                                .foregroundColor(Colors.textBody.color)
                            
                            HStack {
                                Spacer()
                                Button("액션") {
                                    print("Card action tapped")
                                }
                                .foregroundColor(Colors["brand-primary"]?.swiftUIColor ?? Color.blue)
                                .fontWeight(.medium)
                            }
                        }
                        .padding()
                        .background(Colors["background-card"]?.swiftUIColor ?? Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Colors["border-light"]?.swiftUIColor ?? Color.gray, lineWidth: 1)
                        )
                        .shadow(color: Colors["shadow-color"]?.swiftUIColor ?? Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                        // 상태별 버튼들
                        HStack(spacing: 10) {
                            StatusButton(title: "성공", color: Colors.stateSuccess.color)
                            StatusButton(title: "경고", color: Colors.stateWarning.color)
                            StatusButton(title: "오류", color: Colors.stateError.color)
                            StatusButton(title: "정보", color: Colors.stateInfo.color)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Colors.backgroundMain.color)
    }
}

struct AdaptiveColorSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(Colors["text-heading"]?.swiftUIColor ?? Color.black)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Colors["background-card"]?.swiftUIColor ?? Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Colors["border-light"]?.swiftUIColor ?? Color.gray, lineWidth: 1)
        )
        .shadow(color: Colors["shadow-color"]?.swiftUIColor ?? Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}

struct AdaptiveColorBox: View {
    let colorName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(height: 60)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Colors["border-light"]?.swiftUIColor ?? Color.gray, lineWidth: 1)
                )
            
            Text(colorName)
                .font(.caption)
                                .foregroundColor(Colors.textCaption.color)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}

struct StatusButton: View {
    let title: String
    let color: Color
    
    var body: some View {
        Button(title) {
            print("\(title) button tapped")
        }
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(color)
        .cornerRadius(6)
        .font(.caption)
        .fontWeight(.medium)
    }
}

#Preview("Light Mode") {
    AdaptiveColorTestView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    AdaptiveColorTestView()
        .preferredColorScheme(.dark)
}