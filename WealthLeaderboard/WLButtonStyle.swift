//
//  WLButtonStyle.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

struct WLButtonStyle: ButtonStyle {
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.medium)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(.wlGreen)
            }
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
            .onChange(of: configuration.isPressed) { pressed in
                if pressed {
                    feedbackGenerator.prepare()
                    feedbackGenerator.impactOccurred()
                }
            }
    }
}
