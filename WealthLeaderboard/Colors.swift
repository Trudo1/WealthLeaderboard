//
//  Colors.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

extension Color {
    static let wlGreen = color(r: 117, g: 255, b: 82)
    
    static func color(r: Int, g: Int, b: Int) -> Color {
        Color(.displayP3, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: 1.0)
    }
}
