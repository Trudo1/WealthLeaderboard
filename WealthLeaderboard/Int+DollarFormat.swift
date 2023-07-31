//
//  Int+DollarFormat.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import Foundation

extension Int {
    var dollarFormat: String {
        if self >= 100_000_000_000 {
            let value = Double(self) / 100_000_000_000.0
            return NumberFormatter.dollar.string(from: NSNumber(value: value))! + " billion"
        } else if self >= 100_000_000 {
            let value = Double(self) / 100_000_000.0
            return NumberFormatter.dollar.string(from: NSNumber(value: value))! + " million"
        } else {
            let value = Double(self) / 100.0
            return NumberFormatter.dollar.string(from: NSNumber(value: value))!
        }
    }
}

extension NumberFormatter {
    static let dollar = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
