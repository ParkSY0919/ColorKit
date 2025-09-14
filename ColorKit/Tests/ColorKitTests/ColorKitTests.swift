// ColorKitTests.swift
// Unit tests for ColorKit

import XCTest
@testable import ColorKit

final class ColorKitTests: XCTestCase {
    
    func testColorPaletteLoading() throws {
        // Test that color palette loads successfully
        let palette = ColorPalette.shared
        
        // Should have loaded color themes
        XCTAssertTrue(palette.colorCount > 0, "Color palette should have loaded colors")
        XCTAssertTrue(palette.isLoaded, "Color palette should be loaded")
    }
    
    func testColorsEnum() throws {
        // Test that Colors enum has expected cases
        let allColors = Colors.allCases
        XCTAssertTrue(allColors.count > 0, "Colors enum should have cases")
        
        // Test some expected color cases
        XCTAssertTrue(allColors.contains(.background_primary), "Should contain background_primary")
        XCTAssertTrue(allColors.contains(.text_primary), "Should contain text_primary")
        XCTAssertTrue(allColors.contains(.brand_primary), "Should contain brand_primary")
    }
    
    func testColorThemeAccess() throws {
        // Test accessing color themes
        let theme = ColorKit.theme(for: .background_primary)
        XCTAssertNotNil(theme, "Should be able to access background_primary theme")
        
        if let theme = theme {
            XCTAssertFalse(theme.light.isEmpty, "Light theme should not be empty")
            XCTAssertFalse(theme.dark.isEmpty, "Dark theme should not be empty")
            XCTAssertTrue(theme.light.hasPrefix("#"), "Light color should be hex format")
            XCTAssertTrue(theme.dark.hasPrefix("#"), "Dark color should be hex format")
        }
    }
    
    #if canImport(UIKit)
    func testUIColorExtensions() throws {
        // Test UIColor extensions work
        let color = Colors.background_primary.uiColor
        XCTAssertNotNil(color, "Should create UIColor")
    }
    #endif
    
    #if canImport(SwiftUI)
    @available(iOS 13.0, macOS 10.15, *)
    func testSwiftUIColorExtensions() throws {
        // Test SwiftUI Color extensions work  
        let color = Colors.background_primary.color
        XCTAssertNotNil(color, "Should create SwiftUI Color")
    }
    #endif
    
    func testColorKitValidation() throws {
        // Test ColorKit validation
        XCTAssertTrue(ColorKit.isReady, "ColorKit should be ready")
        XCTAssertGreaterThan(ColorKit.colorCount, 0, "Should have colors loaded")
        
        // Should not have errors
        XCTAssertNil(ColorKit.setupError, "Should not have setup errors")
    }
    
    func testAllColorThemes() throws {
        // Test that all color enum cases have corresponding themes
        for color in Colors.allCases {
            let theme = ColorKit.theme(for: color)
            XCTAssertNotNil(theme, "Color \(color.rawValue) should have a theme")
        }
    }
}
