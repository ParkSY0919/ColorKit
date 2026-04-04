import SwiftUI
import ColorKit

private struct PaletteToken: Identifiable {
    let label: String
    let tokenName: String

    var id: String { "\(label)-\(tokenName)" }
}

private struct TextStyleToken: Identifiable {
    let title: String
    let tokenName: String
    let preview: String

    var id: String { tokenName }
}

struct AdaptiveColorTestView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentConfigFile = "colors-adaptive"

    private let paletteColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private let primaryTokens = [
        PaletteToken(label: "Background dark", tokenName: "primary-darkest"),
        PaletteToken(label: "Dark", tokenName: "primary-dark"),
        PaletteToken(label: "Primary", tokenName: "brand-primary"),
        PaletteToken(label: "Light", tokenName: "primary-light"),
        PaletteToken(label: "Background light", tokenName: "primary-surface")
    ]

    private let secondaryTokens = [
        PaletteToken(label: "Background dark", tokenName: "secondary-darkest"),
        PaletteToken(label: "Dark", tokenName: "secondary-dark"),
        PaletteToken(label: "Secondary", tokenName: "brand-secondary"),
        PaletteToken(label: "Light", tokenName: "secondary-light"),
        PaletteToken(label: "Background", tokenName: "secondary-surface")
    ]

    private let backgroundTokens = [
        PaletteToken(label: "Base", tokenName: "surface-base"),
        PaletteToken(label: "1", tokenName: "surface-1"),
        PaletteToken(label: "2", tokenName: "surface-2"),
        PaletteToken(label: "3", tokenName: "surface-3"),
        PaletteToken(label: "4", tokenName: "surface-4"),
        PaletteToken(label: "5", tokenName: "surface-5")
    ]

    private let statusTokens = [
        PaletteToken(label: "Error dark", tokenName: "error-dark"),
        PaletteToken(label: "Error", tokenName: "state-error"),
        PaletteToken(label: "Error light", tokenName: "error-light"),
        PaletteToken(label: "Warning dark", tokenName: "warning-dark"),
        PaletteToken(label: "Warning", tokenName: "state-warning"),
        PaletteToken(label: "Warning light", tokenName: "warning-light")
    ]

    private let textTokens = [
        TextStyleToken(title: "Primary", tokenName: "text-heading", preview: "가장 강한 제목용 색상"),
        TextStyleToken(title: "Secondary", tokenName: "text-body", preview: "본문과 설명용 색상"),
        TextStyleToken(title: "Disabled", tokenName: "text-disabled", preview: "비활성 상태용 색상"),
        TextStyleToken(title: "Action", tokenName: "brand-primary", preview: "상호작용 강조 색상")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                heroCard

                AdaptiveSectionCard(
                    title: "Primary",
                    subtitle: "메인 브랜드 블루 스케일"
                ) {
                    paletteGrid(primaryTokens)
                }

                AdaptiveSectionCard(
                    title: "Secondary",
                    subtitle: "보조 액센트와 민트 계열"
                ) {
                    paletteGrid(secondaryTokens)
                }

                AdaptiveSectionCard(
                    title: "Backgrounds",
                    subtitle: "표면 단계와 배경 톤"
                ) {
                    paletteGrid(backgroundTokens)
                }

                AdaptiveSectionCard(
                    title: "Signals",
                    subtitle: "경고와 에러 상태 색상"
                ) {
                    paletteGrid(statusTokens)
                }

                AdaptiveSectionCard(
                    title: "Text Colors",
                    subtitle: "텍스트 계층과 현재 HEX 값"
                ) {
                    VStack(spacing: 14) {
                        ForEach(textTokens) { token in
                            AdaptiveTextRow(
                                title: token.title,
                                preview: token.preview,
                                color: displayColor(for: token.tokenName),
                                hex: hexValue(for: token.tokenName)
                            )
                        }
                    }
                }

                AdaptiveSectionCard(
                    title: "Component Preview",
                    subtitle: "실제 컴포넌트 적용 예시"
                ) {
                    VStack(spacing: 16) {
                        previewSummaryCard

                        HStack(spacing: 12) {
                            AdaptiveMetricCard(
                                title: "Primary CTA",
                                value: "4.88x",
                                tint: Colors.brandPrimary.color
                            )

                            AdaptiveMetricCard(
                                title: "Accent",
                                value: "18 swatches",
                                tint: Colors.brandSecondary.color
                            )
                        }

                        HStack(spacing: 10) {
                            AdaptiveStatusPill(
                                title: "Success",
                                fill: Colors.stateSuccess.color,
                                foreground: contrastColor(for: "state-success")
                            )
                            AdaptiveStatusPill(
                                title: "Warning",
                                fill: Colors.stateWarning.color,
                                foreground: contrastColor(for: "state-warning")
                            )
                            AdaptiveStatusPill(
                                title: "Error",
                                fill: Colors.stateError.color,
                                foreground: contrastColor(for: "state-error")
                            )
                        }

                        HStack(spacing: 12) {
                            AdaptiveActionButton(
                                title: "Primary Action",
                                background: Colors.accentPrimary.color,
                                foreground: contrastColor(for: "accent-primary")
                            )

                            AdaptiveActionButton(
                                title: "Secondary",
                                background: Colors.backgroundElevated.color,
                                foreground: Colors.textHeading.color,
                                border: Colors.borderMedium.color
                            )
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Colors.backgroundMain.color.ignoresSafeArea())
        .onAppear {
            ColorKit.configure(jsonFileName: "colors-adaptive")
            currentConfigFile = "colors-adaptive"
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Adaptive Palette Showcase")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("브랜드, 배경, 상태, 텍스트 토큰을 한 화면에서 확인합니다.")
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.88))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 16)

                VStack(alignment: .trailing, spacing: 8) {
                    HeroInfoChip(title: "Mode", value: colorScheme == .dark ? "Dark" : "Light")
                    HeroInfoChip(title: "Source", value: currentConfigFile)
                }
            }

            HStack(spacing: 12) {
                AdaptiveModeBadge(
                    title: "Primary",
                    tint: Colors.brandPrimary.color
                )
                AdaptiveModeBadge(
                    title: "Secondary",
                    tint: Colors.brandSecondary.color
                )
                AdaptiveModeBadge(
                    title: "Surface",
                    tint: Colors.surfaceBase.color
                )
            }
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [Colors.primaryDarkest.color, Colors.primaryDark.color, Colors.brandPrimary.color],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Colors.primaryLight.color.opacity(0.28), lineWidth: 1)
        )
        .cornerRadius(24)
        .shadow(color: Colors.shadowColor.color, radius: 18, x: 0, y: 10)
    }

    private var previewSummaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Design Token Summary")
                        .font(.headline)
                        .foregroundColor(Colors.textHeading.color)

                    Text("버튼, 대비, 배경, 상태 색상")
                        .font(.caption)
                        .foregroundColor(Colors.textCaption.color)
                }

                Spacer()

                Text(colorScheme == .dark ? "Dark" : "Light")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(contrastColor(for: "brand-primary"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Colors.brandPrimary.color)
                    .cornerRadius(999)
            }

            Text("카드, 버튼, 배지, 텍스트에 적용된 예시입니다.")
                .font(.body)
                .foregroundColor(Colors.textBody.color)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Colors.brandPrimary.color, Colors.brandSecondary.color],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 8)
                .cornerRadius(999)
        }
        .padding(18)
        .background(Colors.backgroundCard.color)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Colors.borderLight.color, lineWidth: 1)
        )
        .cornerRadius(18)
    }

    private func paletteGrid(_ tokens: [PaletteToken]) -> some View {
        LazyVGrid(columns: paletteColumns, spacing: 12) {
            ForEach(tokens) { token in
                AdaptivePaletteTile(
                    title: token.label,
                    hex: hexValue(for: token.tokenName),
                    fill: displayColor(for: token.tokenName),
                    foreground: contrastColor(for: token.tokenName)
                )
            }
        }
    }

    private func displayColor(for tokenName: String) -> Color {
        Colors[tokenName]?.swiftUIColor ?? Color.gray
    }

    private func hexValue(for tokenName: String) -> String {
        guard let theme = Colors[tokenName] else {
            return "N/A"
        }
        return colorScheme == .dark ? theme.dark : theme.light
    }

    private func contrastColor(for tokenName: String) -> Color {
        let hex = hexValue(for: tokenName)
        guard let rgb = rgbComponents(from: hex) else {
            return .white
        }
        let backgroundLuminance = relativeLuminance(for: rgb)
        let whiteContrast = contrastRatio(between: backgroundLuminance, and: 1)
        let darkContrast = contrastRatio(between: backgroundLuminance, and: darkInkLuminance)
        return darkContrast > whiteContrast ? darkInkColor : .white
    }

    private func rgbComponents(from hex: String) -> (red: Double, green: Double, blue: Double)? {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        let rgbHex: String

        switch cleaned.count {
        case 6:
            rgbHex = cleaned
        case 8:
            rgbHex = String(cleaned.suffix(6))
        default:
            return nil
        }

        guard let value = UInt64(rgbHex, radix: 16) else {
            return nil
        }

        return (
            red: Double((value & 0xFF0000) >> 16) / 255,
            green: Double((value & 0x00FF00) >> 8) / 255,
            blue: Double(value & 0x0000FF) / 255
        )
    }

    private var darkInkColor: Color {
        Color(hex: "#15171C") ?? .black
    }

    private var darkInkLuminance: Double {
        relativeLuminance(
            for: (
                red: Double(0x15) / 255,
                green: Double(0x17) / 255,
                blue: Double(0x1C) / 255
            )
        )
    }

    private func relativeLuminance(for rgb: (red: Double, green: Double, blue: Double)) -> Double {
        let red = linearize(rgb.red)
        let green = linearize(rgb.green)
        let blue = linearize(rgb.blue)
        return (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
    }

    private func linearize(_ value: Double) -> Double {
        value <= 0.03928 ? (value / 12.92) : pow((value + 0.055) / 1.055, 2.4)
    }

    private func contrastRatio(between lhs: Double, and rhs: Double) -> Double {
        let lighter = max(lhs, rhs)
        let darker = min(lhs, rhs)
        return (lighter + 0.05) / (darker + 0.05)
    }
}

private struct AdaptiveSectionCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Colors.textHeading.color)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(Colors.textCaption.color)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Colors.backgroundCard.color)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Colors.borderLight.color, lineWidth: 1)
        )
        .cornerRadius(20)
        .shadow(color: Colors.shadowColor.color, radius: 8, x: 0, y: 4)
    }
}

private struct AdaptivePaletteTile: View {
    let title: String
    let hex: String
    let fill: Color
    let foreground: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 16)
                .fill(fill)
                .frame(height: 110)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(foreground.opacity(0.12), lineWidth: 1)
                )
                .overlay(
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text(hex.uppercased())
                            .font(.caption2)
                    }
                    .foregroundColor(foreground)
                    .padding(12)
                    ,
                    alignment: .bottomLeading
                )
        }
    }
}

private struct AdaptiveTextRow: View {
    let title: String
    let preview: String
    let color: Color
    let hex: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
                .padding(.top, 5)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)

                Text(preview)
                    .font(.callout)
                    .foregroundColor(color)
            }

            Spacer(minLength: 12)

            Text(hex.uppercased())
                .font(.caption2)
                .foregroundColor(Colors.textCaption.color)
        }
    }
}

private struct AdaptiveMetricCard: View {
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Colors.textCaption.color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Colors.textHeading.color)

            Capsule()
                .fill(tint)
                .frame(height: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Colors.backgroundElevated.color)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Colors.borderLight.color, lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

private struct AdaptiveStatusPill: View {
    let title: String
    let fill: Color
    let foreground: Color

    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(foreground)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(fill)
            .cornerRadius(999)
    }
}

private struct AdaptiveActionButton: View {
    let title: String
    let background: Color
    let foreground: Color
    var border: Color? = nil

    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(foreground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(background)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(border ?? .clear, lineWidth: 1)
            )
            .cornerRadius(14)
    }
}

private struct AdaptiveModeBadge: View {
    let title: String
    let tint: Color

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(tint)
                .frame(width: 10, height: 10)

            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Colors.textHeading.color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Colors.backgroundElevated.color)
        .overlay(
            RoundedRectangle(cornerRadius: 999)
                .stroke(Colors.borderLight.color, lineWidth: 1)
        )
        .cornerRadius(999)
    }
}

private struct HeroInfoChip: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(title.uppercased())
                .font(.caption2)
                .foregroundColor(Color.white.opacity(0.72))

            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Colors.surfaceBase.color.opacity(0.16))
        .cornerRadius(12)
    }
}

#Preview("Adaptive Light") {
    AdaptiveColorTestView()
        .preferredColorScheme(.light)
}

#Preview("Adaptive Dark") {
    AdaptiveColorTestView()
        .preferredColorScheme(.dark)
}
