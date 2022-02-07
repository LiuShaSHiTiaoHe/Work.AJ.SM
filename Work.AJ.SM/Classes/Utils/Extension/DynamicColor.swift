//
//  DynamicColor.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation

extension UIColor {
    
    // MARK: - extension 适配深色模式 浅色模式 非layer
    ///lightHex  浅色模式的颜色（十六进制）
    ///darkHex   深色模式的颜色（十六进制）
    ///return    返回一个颜色（UIColor）
    static func color(lightHex: String,
                      darkHex: String,
                      alpha: CGFloat = 1.0)
        -> UIColor {
        let light = UIColor(hex: lightHex, alpha) ?? UIColor.black
        let dark =  UIColor(hex: darkHex, alpha) ?? UIColor.white
            
        return color(lightColor: light, darkColor: dark)
    }

    // MARK: - extension 适配深色模式 浅色模式 非layer
    ///lightColor  浅色模式的颜色（UIColor）
    ///darkColor   深色模式的颜色（UIColor）
    ///return    返回一个颜色（UIColor）
   static func color(lightColor: UIColor,
                     darkColor: UIColor)
       -> UIColor {
       if #available(iOS 13.0, *) {
          return UIColor { (traitCollection) -> UIColor in
               if traitCollection.userInterfaceStyle == .dark {
                   return darkColor
               }else {
                   return lightColor
               }
           }
       } else {
          return lightColor
       }
   }

   
   // MARK: - 构造函数（十六进制）
    ///hex  颜色（十六进制）
    ///alpha   透明度
   convenience init?(hex : String,
                     _ alpha : CGFloat = 1.0) {
       var cHex = hex.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
       guard cHex.count >= 6 else {
           return nil
       }
       if cHex.hasPrefix("0X") {
           cHex = String(cHex[cHex.index(cHex.startIndex, offsetBy: 2)..<cHex.endIndex])
       }
       if cHex.hasPrefix("#") {
           cHex = String(cHex[cHex.index(cHex.startIndex, offsetBy: 1)..<cHex.endIndex])
       }

       var r : UInt64 = 0
       var g : UInt64  = 0
       var b : UInt64  = 0

       let rHex = cHex[cHex.startIndex..<cHex.index(cHex.startIndex, offsetBy: 2)]
       let gHex = cHex[cHex.index(cHex.startIndex, offsetBy: 2)..<cHex.index(cHex.startIndex, offsetBy: 4)]
       let bHex = cHex[cHex.index(cHex.startIndex, offsetBy: 4)..<cHex.index(cHex.startIndex, offsetBy: 6)]

       Scanner(string: String(rHex)).scanHexInt64(&r)
       Scanner(string: String(gHex)).scanHexInt64(&g)
       Scanner(string: String(bHex)).scanHexInt64(&b)

       self.init(red:CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
   }
    
    public convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha)
    }
    
    public class var randomColor: UIColor {
        get
        {
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

