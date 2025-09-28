import SwiftUI
import ColorKit

struct CodeGenerationTestView: View {
    @State private var currentJsonFile = "colors"
    @State private var showGeneratedCode = false
    @State private var generatedCodeText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("ColorKit 코드 생성 테스트")
                    .font(.title)
                    .foregroundColor(Colors.textHeading.color)
                
                // JSON 설정 스위처
                VStack(spacing: 15) {
                    Text("JSON 설정 파일 전환")
                        .font(.headline)
                        .foregroundColor(Colors.textHeading.color)
                    
                    HStack(spacing: 10) {
                        Button("단일 컬러") {
                            ColorKit.configure(jsonFileName: "colors")
                            currentJsonFile = "colors"
                        }
                        .foregroundColor(currentJsonFile == "colors" ? Colors.textInverse.color : Colors.brandPrimary.color)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(currentJsonFile == "colors" ? Colors.brandPrimary.color : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Colors.brandPrimary.color, lineWidth: 1)
                        )
                        .cornerRadius(8)
                        
                        Button("적응형 컬러") {
                            ColorKit.configure(jsonFileName: "colors-adaptive")
                            currentJsonFile = "colors-adaptive"
                        }
                        .foregroundColor(currentJsonFile == "colors-adaptive" ? Colors.textInverse.color : Colors.brandSecondary.color)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(currentJsonFile == "colors-adaptive" ? Colors.brandSecondary.color : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Colors.brandSecondary.color, lineWidth: 1)
                        )
                        .cornerRadius(8)
                    }
                    
                    Text("현재 설정: \(currentJsonFile).json")
                        .font(.caption)
                        .foregroundColor(Colors.textCaption.color)
                        
                }
                .padding()
                .background(Colors.backgroundCard.color)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Colors.borderLight.color, lineWidth: 1)
                )
                
                // 자동 생성 속성 테스트
                VStack(spacing: 15) {
                    Text("자동 생성된 타입 안전 속성")
                        .font(.headline)
                        .foregroundColor(Colors.textHeading.color)
                    
                    Text("JSON 파일에서 자동으로 생성된 Swift 속성들을 사용합니다")
                        .font(.caption)
                        .foregroundColor(Colors.textCaption.color)
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        // 자동 생성된 속성들 테스트
                        GeneratedPropertyBox(propertyName: "brandPrimary", color: Colors.brandPrimary.color)
                        GeneratedPropertyBox(propertyName: "backgroundMain", color: Colors.backgroundMain.color)
                        GeneratedPropertyBox(propertyName: "textHeading", color: Colors.textHeading.color)
                        GeneratedPropertyBox(propertyName: "stateSuccess", color: Colors.stateSuccess.color)
                        GeneratedPropertyBox(propertyName: "accentPrimary", color: Colors.accentPrimary.color)
                        GeneratedPropertyBox(propertyName: "borderLight", color: Colors.borderLight.color)
                    }
                }
                .padding()
                .background(Colors.backgroundCard.color)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Colors.borderLight.color, lineWidth: 1)
                )
                
                // 동적 접근 vs 정적 접근 비교
                VStack(spacing: 15) {
                    Text("접근 방식 비교")
                        .font(.headline)
                        .foregroundColor(Colors.textHeading.color)
                    
                    VStack(spacing: 10) {
                        AccessMethodComparison(
                            title: "브랜드 컬러",
                            staticAccess: "Colors.brandPrimary.color",
                            dynamicAccess: "Colors[\"brand-primary\"].color",
                            staticColor: Colors["brand-primary"]?.swiftUIColor ?? Color.blue,
                            dynamicColor: Colors["brand-primary"]?.swiftUIColor ?? Color.blue
                        )
                        
                        AccessMethodComparison(
                            title: "배경 컬러",
                            staticAccess: "Colors.backgroundMain.color",
                            dynamicAccess: "Colors[\"background-main\"].color",
                            staticColor: Colors["background-main"]?.swiftUIColor ?? Color.white,
                            dynamicColor: Colors["background-main"]?.swiftUIColor ?? Color.white
                        )
                        
                        AccessMethodComparison(
                            title: "존재하지 않는 컬러",
                            staticAccess: "Colors.unknownColor.color",
                            dynamicAccess: "Colors[\"unknown-color\"].color",
                            staticColor: Colors["unknown-color"]?.swiftUIColor ?? Color.gray,
                            dynamicColor: Colors["unknown-color"]?.swiftUIColor ?? Color.gray
                        )
                    }
                }
                .padding()
                .background(Colors.backgroundCard.color)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Colors.borderLight.color, lineWidth: 1)
                )
                
                // 코드 생성 버튼
                VStack(spacing: 15) {
                    Text("자동 코드 생성")
                        .font(.headline)
                        .foregroundColor(Colors.textHeading.color)
                    
                    Button("Generated Extensions 출력") {
                        #if DEBUG
                        ColorKit.printGeneratedExtensions()
                        #endif
                        showGeneratedCode = true
                        generatedCodeText = "콘솔에서 생성된 코드를 확인하세요!"
                    }
                    .foregroundColor(Colors.textInverse.color)
                    .padding()
                    .background(Colors.brandTertiary.color)
                    .cornerRadius(8)
                    
                    if showGeneratedCode {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("생성된 코드 정보")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Colors.textHeading.color)
                            
                            Text(generatedCodeText)
                                .font(.caption)
                                .foregroundColor(Colors.textBody.color)
                            
                            Text("Xcode의 콘솔창에서 전체 생성된 Swift 코드를 확인할 수 있습니다.")
                                .font(.caption)
                                .foregroundColor(Colors.textCaption.color)
                        }
                        .padding()
                        .background(Colors["background-secondary"]?.swiftUIColor ?? Color.gray)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Colors.backgroundCard.color)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Colors.borderLight.color, lineWidth: 1)
                )
                
                // Progressive Enhancement 예시
                VStack(spacing: 15) {
                    Text("Progressive Enhancement")
                        .font(.headline)
                        .foregroundColor(Colors.textHeading.color)
                    
                    Text("컬러가 정의되기 전에 UI 코드를 작성할 수 있습니다")
                        .font(.caption)
                        .foregroundColor(Colors.textCaption.color)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 10) {
                        // 존재하는 컬러
                        HStack {
                            Text("정의된 컬러:")
                                .foregroundColor(Colors.textBody.color)
                            Rectangle()
                                .fill(Colors.brandPrimary.color)
                                .frame(width: 30, height: 20)
                                .cornerRadius(4)
                            Text("brandPrimary")
                                .font(.caption)
                                .foregroundColor(Colors.textCaption.color)
                        }
                        
                        // 존재하지 않는 컬러 (자동 fallback)
                        HStack {
                            Text("미정의 컬러:")
                                .foregroundColor(Colors.textBody.color)
                            Rectangle()
                                .fill(Colors.futureColor.color)
                                .frame(width: 30, height: 20)
                                .cornerRadius(4)
                            Text("futureColor (gray fallback)")
                                .font(.caption)
                                .foregroundColor(Colors.textCaption.color)
                        }
                    }
                }
                .padding()
                .background(Colors.backgroundCard.color)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Colors.borderLight.color, lineWidth: 1)
                )
            }
            .padding()
        }
        .background(Colors["background-main"]?.swiftUIColor ?? Color.white)
    }
}

struct GeneratedPropertyBox: View {
    let propertyName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(height: 50)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Colors.borderLight.color, lineWidth: 1)
                )
            
            VStack(spacing: 4) {
                Text("Colors.\(propertyName)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Colors.textBody.color)
                
                Text("자동 생성됨")
                    .font(.caption2)
                    .foregroundColor(Colors.textCaption.color)
            }
            .multilineTextAlignment(.center)
        }
    }
}

struct AccessMethodComparison: View {
    let title: String
    let staticAccess: String
    let dynamicAccess: String
    let staticColor: Color
    let dynamicColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Colors.textHeading.color)
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("정적 접근")
                        .font(.caption)
                        .foregroundColor(Colors.textCaption.color)
                    
                    HStack {
                        Rectangle()
                            .fill(staticColor)
                            .frame(width: 20, height: 20)
                            .cornerRadius(4)
                        
                        Text(staticAccess)
                            .font(.caption)
                            .foregroundColor(Colors.textBody.color)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("동적 접근")
                        .font(.caption)
                        .foregroundColor(Colors.textCaption.color)
                    
                    HStack {
                        Rectangle()
                            .fill(dynamicColor)
                            .frame(width: 20, height: 20)
                            .cornerRadius(4)
                        
                        Text(dynamicAccess)
                            .font(.caption)
                            .foregroundColor(Colors.textBody.color)
                    }
                }
            }
        }
        .padding()
        .background(Colors.backgroundSecondary.color)
        .cornerRadius(8)
    }
}

#Preview("Single Colors") {
    CodeGenerationTestView()
        .onAppear {
            ColorKit.configure(jsonFileName: "colors")
        }
}

#Preview("Adaptive Colors") {
    CodeGenerationTestView()
        .onAppear {
            ColorKit.configure(jsonFileName: "colors-adaptive")
        }
}
