import SwiftUI
import ColorKit

struct XcassetsColorTestView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Assets.xcassets 컬러 테스트")
                    .font(.title)
                    .foregroundColor(.primary)
                
                // 현재 모드 표시
                HStack {
                    Text("현재 모드:")
                        .foregroundColor(.secondary)
                    Text(colorScheme == .dark ? "Dark" : "Light")
                        .foregroundColor(.accentColor)
                        .fontWeight(.bold)
                }
                .padding()
                .background(Color("TestBackground"))
                .cornerRadius(10)
                .shadow(radius: 2)
                
                // Xcode Assets 컬러 테스트
                VStack(spacing: 15) {
                    Text("Xcode Assets 컬러")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                        XcassetsColorBox(colorName: "Brand Primary", colorAsset: "BrandPrimary")
                        XcassetsColorBox(colorName: "Test Background", colorAsset: "TestBackground")
                        XcassetsColorBox(colorName: "Accent Color", color: .accentColor)
                        XcassetsColorBox(colorName: "System Primary", color: .primary)
                        XcassetsColorBox(colorName: "System Secondary", color: .secondary)
                        XcassetsColorBox(colorName: "System Blue", color: .blue)
                    }
                }
                .padding()
                .background(Color("TestBackground"))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // 실제 사용 예시
                VStack(spacing: 15) {
                    Text("실제 사용 예시")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // 커스텀 브랜드 컬러 사용 버튼
                    Button("브랜드 컬러 버튼") {
                        print("Brand color button tapped")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("BrandPrimary"))
                    .cornerRadius(8)
                    
                    // 시스템 컬러와 커스텀 컬러 비교
                    HStack(spacing: 15) {
                        VStack {
                            Text("시스템 Blue")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: 50)
                                .cornerRadius(8)
                        }
                        
                        VStack {
                            Text("커스텀 Brand")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Rectangle()
                                .fill(Color("BrandPrimary"))
                                .frame(height: 50)
                                .cornerRadius(8)
                        }
                    }
                    
                    // 배경색 적용 카드
                    VStack(alignment: .leading, spacing: 10) {
                        Text("커스텀 배경 카드")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("이 카드는 Assets.xcassets에 정의된 TestBackground 컬러를 사용합니다. Light/Dark 모드에 따라 자동으로 변경됩니다.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color("TestBackground"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.tertiary, lineWidth: 1)
                    )
                    .shadow(radius: 2)
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(12)
                
                // 컬러 비교 섹션
                VStack(spacing: 15) {
                    Text("컬러 소스 비교")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("같은 용도의 컬러를 다른 방식으로 정의했을 때의 차이점을 확인할 수 있습니다.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 10) {
                        VStack {
                            Text("JSON 컬러")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Rectangle()
                                .fill(Colors.accentPrimary.color)
                                .frame(height: 40)
                                .cornerRadius(6)
                        }
                        
                        VStack {
                            Text("Assets 컬러")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Rectangle()
                                .fill(Color("BrandPrimary"))
                                .frame(height: 40)
                                .cornerRadius(6)
                        }
                        
                        VStack {
                            Text("시스템 컬러")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Rectangle()
                                .fill(.brandPrimary)
                                .frame(height: 40)
                                .cornerRadius(6)
                        }
                    }
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(12)
            }
            .padding()
        }
        .background(Color("TestBackground"))
    }
}

struct XcassetsColorBox: View {
    let colorName: String
    let color: Color?
    let colorAsset: String?
    
    init(colorName: String, color: Color) {
        self.colorName = colorName
        self.color = color
        self.colorAsset = nil
    }
    
    init(colorName: String, colorAsset: String) {
        self.colorName = colorName
        self.color = nil
        self.colorAsset = colorAsset
    }
    
    var displayColor: Color {
        if let color = color {
            return color
        } else if let colorAsset = colorAsset {
            return Color(colorAsset)
        } else {
            return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(displayColor)
                .frame(height: 60)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.tertiary, lineWidth: 1)
                )
            
            Text(colorName)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}

#Preview("Light Mode") {
    XcassetsColorTestView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    XcassetsColorTestView()
        .preferredColorScheme(.dark)
}
