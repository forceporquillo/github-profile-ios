//
//  LanguageColorsUtil.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/1/24.
//

import SwiftUI

typealias LanguageColor = [String: String]

extension String {
    
    static var languageColors: LanguageColor = [:]
    
    static func loadLanguageColors() -> LanguageColor {
        if languageColors.isEmpty {
            if let url = Bundle.main.url(forResource: "github_languages", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    languageColors = try decoder.decode(LanguageColor.self, from: data)
                } catch {
                    print("Error loading or parsing JSON: \(error)")
                }
            } else {
                print("Did not find the JSON file.")
            }
        }
        return languageColors
    }
    
    func colorForLanguage() -> Color {
        let colors = String.loadLanguageColors()
        let colorHex = colors[self]
        return Color(hex: colorHex ?? "#000000") ?? Color.black
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
