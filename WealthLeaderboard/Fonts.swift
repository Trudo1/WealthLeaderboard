//
//  Fonts.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

extension Font {
    static let small = lg(ofSize: 16)
    static let sm = satoshi(ofSize: 16)
    static let medium = lg(ofSize: 18)
    static let large = satoshi(ofSize: 19)
    
    static func lg(ofSize size: CGFloat) -> Font {
        Font.custom(.lg, size: size)
    }
    static func satoshi(ofSize size: CGFloat) -> Font {
        Font.custom(.satoshi, size: size)
    }
}

extension String {
    static let lg = "LabGrotesque-Medium"
    static let satoshi = "Satoshi-Bold"
}
