// Colors+Stub.swift
// 컴파일을 위한 Colors enum 스텁
// 실제 색상 값은 런타임에 ColorPalette에서 동적으로 로드됩니다

import Foundation

/// ColorKit에서 사용하는 색상 enum
/// 이 enum은 컴파일 타임에 타입 안전성을 제공하며,
/// 실제 색상 값은 런타임에 디자인 토큰에서 동적으로 로드됩니다.
public enum Colors: String, CaseIterable {
    // Background colors
    case background_primary = "Background.primary"
    case background_secondary = "Background.secondary"
    case background_tertiary = "Background.tertiary"
    
    // Text colors
    case text_primary = "Text.primary"
    case text_secondary = "Text.secondary"
    case text_tertiary = "Text.tertiary"
    case text_inverse = "Text.inverse"
    
    // Brand colors
    case brand_primary = "Brand.primary"
    case brand_secondary = "Brand.secondary"
    case brand_light = "Brand.light"
    
    // Status colors
    case status_success = "Status.success"
    case status_warning = "Status.warning"
    case status_error = "Status.error"
    case status_info = "Status.info"
    
    // Border colors
    case border_default = "Border.default"
    case border_strong = "Border.strong"
    case border_focus = "Border.focus"
    
    /// 색상의 표시 이름을 반환합니다
    public var displayName: String {
        return rawValue.replacingOccurrences(of: ".", with: " ")
            .capitalized
    }
    
    /// 색상의 카테고리를 반환합니다
    public var category: String {
        return String(rawValue.split(separator: ".").first ?? "")
    }
    
    /// 색상의 변형명을 반환합니다
    public var variant: String {
        let components = rawValue.split(separator: ".")
        return components.count > 1 ? String(components[1]) : ""
    }
}
