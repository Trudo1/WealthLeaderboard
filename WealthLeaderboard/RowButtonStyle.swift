//
//  RowButtonStyle.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

struct RowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                configuration.isPressed ? Color.primary.opacity(0.2) : .white
            }
    }
}
