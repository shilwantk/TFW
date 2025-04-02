//
//  Theme.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import Foundation
import SwiftUI

struct WhiteLabel: Codable {
    var buttonColor:     String?
    var disabled:        String?
    var black:           String?
    var orange:          String?
    var viewBackground:  String?
    var background:      String?
    var green:           String?
    var blue:            String?
    var gray:            String?
    var unselectedGray:  String?
    var border:          String?
    var lightGreen:      String?
    var icon:            String?
    var domain:          String
}

struct GradinetColor {
    var primary: Color
    var secondary:Color
}

struct Theme {
    
    var isMainTheme:Bool = true
    
    static var shared = Theme()
    
    ///#0ABF89
    var buttonColor:Color = Color(hex: "E97100")
    
    ///#BEC6CD
    var disabled:Color    = Color(hex: "BEC6CD")
    
    ///#001018
    var black:Color        = Color(hex: "001018")
    
    
    ///#FFC079
    var lightOrange: Color      = Color(hex: "FFC079")
    
    ///#DCDFDF
    var editGray: Color      = Color(hex: "DCDFDF")
    
    var red: Color      = Color(hex: "E42B57")
    var zalaRed: Color      = Color(hex: "A73575")
    
    
    ///#F5F5F5
    var viewBackground:Color   = Color(hex: "F5F5F5")

    ///#F7F8FA
    var background:Color   = Color(hex: "F7F8FA")
    
    //ZALA
    var orangeGradientColor:GradinetColor = GradinetColor(primary: Color(hex: "FEAC4E"), secondary: Color(hex: "F96738"))
    
    var grayGradientColor:GradinetColor = GradinetColor(primary: Color(hex: "B4B0B4"), secondary: Color(hex: "2E2D2E"))
    
    var lightBlueGradientColor:GradinetColor = GradinetColor(primary: Color(hex: "90E2FC"), secondary: Color(hex: "13bbe2"))
    var blackGradientColor:GradinetColor = GradinetColor(primary: Color(hex: "000000"), secondary: Color(hex: "000000"))
    var greenGradientColor:GradinetColor = GradinetColor(primary: Color(hex: "AAF387"), secondary: Color(hex: "46B643"))
    
    
    var darkGradientColor:GradinetColor = GradinetColor(primary: Color(hex: "#191819").opacity(0), secondary: Color(hex: "#191819"))
    
    ///#2E2D2E
    var baseSlate:  Color      = Color(hex: "2E2D2E")
    
    ///#4ADF6B
    var green:  Color      = Color(hex: "4ADF6B")
    
    ///#38C760
    var zalaGreen:  Color      = Color(hex: "38C760")
    
    ///#5BE683
    var brightGreen:  Color      = Color(hex: "5BE683")
    
    ///#FC8442
    var orange:  Color      = Color(hex: "FC8442")
    
    ///#529FF9
    var blue: Color        = Color(hex: "13bbe2")
    
    var zalaBlue: Color        = Color(hex: "13bbe2")    
    
        
    ///#3B3A3B
    var darkText: Color    = Color(hex: "3B3A3B")
    
    ///#191819
    var upDownButton: Color    = Color(hex: "191819")
    
    
    
    ///#90E2FC
    var lightBlue:Color   = Color(hex: "90E2FC")
    
    ///#252425
    var mediumBlack:Color   = Color(hex: "252425")
    
    ///#C72881
    var purple:Color   = Color(hex: "C72881")
    
    ///#413F41
    var medGray:Color   = Color(hex: "413F41")
    
    
    
    
    
    //####-----####
    
    ///#646F79
    var gray: Color        = Color(hex: "646F79")
    
    ///#B4B0B4
    var placeholderGray: Color        = Color(hex: "B4B0B4")
    
    
    ///#DAD8DA
    var grayStroke: Color        = Color(hex: "#DAD8DA")
    
    
    ///#8996A2
    var unselectedGray: Color    = Color(hex: "8996A2")
    
    
    ///#E9EBEB
    var graySplit: Color    = Color(hex: "E9EBEB")
    
    
    
    
    ///#D5DCE2
    var border: Color            = Color(hex: "D5DCE2")
    
    ///#E6F9F3
    var lightGreen: Color        = Color(hex: "E6F9F3")
    
    
    var taskBackground: Color        = Color(hex: "F7F8F8")
    var taskUnselectedGray: Color        = Color(hex: "747A7A")
    
    ///#E971001A
    var householdOrange: Color        = Color(hex: "E971001A")
    
    ///#E3F8FA
    var householdGreen: Color        = Color(hex: "E3F8FA")
    
    ///#2370CB1A
    var householdBlue: Color        = Color(hex: "#2370CB1A")
    
    private init() { }   
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
//    func hexString() -> String {
//
//        let components = self.cgColor?.components
//        let r: CGFloat = components?[0] ?? 0.0
//        let g: CGFloat = components?[1] ?? 0.0
//        let b: CGFloat = components?[2] ?? 0.0
//
//        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
//        return hexString
//    }
    
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

extension Text {
    
    enum Size:CGFloat {
        ///    .x13:       return 13.0`.
        case x13
        ///    .x16:       return 16.0`.
        case x16
        ///    .x18:       return 18.0`.
        case x18
        ///    .x19:       return 19.0`.
        case x19
        ///    .x20:       return 20.0`.
        case x20
        ///    .x22:       return 22.0`.
        case x22
        ///    .x28:       return 28.0`.
        case x28
        ///    .x44:       return 44.0`.
        case x44
        ///   `.xSmall:       return 11.0`.
        case xSmall
        ///   `.small:       return 13.0`.
        case small
        /// `.regular:     return 15.0`.
        case regular
        ///    `.large:       return 20.0`.
        case large
        ///   `.extra:       return 28.0`.
        case extra
        ///    `.huge:        return 34.0`.
        ///
        case x55
        ///    `.large:       return 55.0`.
        case huge
        ///  `Default 15.0 fontSize(custom:CGFloat = 15.0)`.
        case custom
        
        func fontSize(custom:CGFloat = 15.0) -> CGFloat {
            switch self {
            case .xSmall:     return 11.0 //should be 13?
            case .small:     return 14.0 //should be 13?
            case .regular:  return 15.0
            case .x13:      return 13.0
            case .x16:      return 16.0
            case .x18:      return 18.0
            case .x19:      return 19.0
            case .x20:      return 20.0
            case .x44:      return 44.0
            case .x22:      return 22.0
            case .x28:      return 28.0
            case .large:     return 20.0
            case .extra:    return 28.0
            case .huge:     return 34.0
            case .x55:      return 55.0
            case .custom:     return custom            
            }
        }
    }

    enum Weight {
        case w100, w200, w300, w400, w500, w600, w700, w800, w900
        
        func fontWeight() -> Font.Weight {
            switch self {
            case .w100: return .ultraLight
            case .w200: return .thin
            case .w300: return .light
            case .w400: return .regular
            case .w500: return .medium
            case .w600: return .semibold
            case .w700: return .bold
            case .w800: return .heavy
            case .w900: return .black
            }
        }
    }

    func style(color:Color = .white, size:Size = .regular, weight: Weight = .w400) -> Text {
        self.foregroundColor(color)
            .font(.system(size: size.fontSize()))
       .fontWeight(weight.fontWeight())
    }
}
