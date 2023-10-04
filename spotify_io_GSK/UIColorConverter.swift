//
//  UIColorConverter.swift
//  spotify_io_GSK
//
//  Created by coding on 04/10/2023.
//

import Foundation
import UIKit

// Color converter: hex to rgb
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        precondition(hexFormatted.count == 6, "Invalid hex code used.")
        
        var hexValue: UInt64 = 0
        
        Scanner(string: hexFormatted).scanHexInt64(&hexValue)
        
        let r = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hexValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
