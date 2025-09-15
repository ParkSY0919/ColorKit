// UIColor+Extensions.swift
// UIKit extensions

#if canImport(UIKit)
import UIKit

extension UIColor {
    public convenience init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        
        let hasAlpha = cleaned.count == 8
        let a = hasAlpha ? CGFloat((value & 0xFF000000) >> 24) / 255 : 1
        let r = CGFloat((value & 0xFF0000) >> 16) / 255
        let g = CGFloat((value & 0x00FF00) >> 8) / 255
        let b = CGFloat( value & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

@available(iOS 14.0, *)
extension Colors {
    /// UIKit에서 사용할 수 있는 UIColor
    /// 자동으로 Light/Dark 모드를 지원합니다
    public var uiColor: UIColor {
        guard let theme = ColorPalette.shared.theme(for: rawValue) else {
            assertionFailure("⚠️ ColorKit: Color '\(rawValue)' not found")
            return .systemPink // 디버깅용 컬러
        }
        
        return UIColor { traits in
            let hex = traits.userInterfaceStyle == .dark ? theme.dark : theme.light
            return UIColor(hex: hex)
        }
    }
}
#endif
