//
//  LanguageColorsUtil.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/1/24.
//

import SwiftUI

typealias LanguageColor = [String: String]

final class LanguageColorsUtil {
    
    private static var colors: LanguageColor = [:]
    
    private init() {}
    
    static func loadColors() -> LanguageColor {
        if colors.isEmpty {
            if let url = Bundle.main.url(forResource: "github_languages", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    colors = try decoder.decode(LanguageColor.self, from: data)
                } catch {
                    print("Error loading or parsing JSON: \(error)")
                }
            } else {
                print("Did not found...")
            }
        }
        return colors
    }
    
    static func getColorForLanguage(_ language: String?) -> Color {
        guard let language = language, !language.isEmpty else { return Color.black }
        let colors = loadColors()[language]
        return Color(hex: colors ?? "#0000000") ?? Color.black
    }
}

extension Color {
    init?(hex: String) {
        let r, g, b: Double
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = Double((hexNumber & 0xff0000) >> 16) / 255
                g = Double((hexNumber & 0x00ff00) >> 8) / 255
                b = Double(hexNumber & 0x0000ff) / 255
                
                self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
                return
            }
        }
        return nil
    }
}
