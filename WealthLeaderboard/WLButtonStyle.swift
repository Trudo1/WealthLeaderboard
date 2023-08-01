//
//  WLButtonStyle.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

struct WLButtonStyle: ButtonStyle {
    @Binding var loading: Bool
    
    init(loading: Binding<Bool> = .constant(false)) {
        self._loading = loading
    }
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(loading ? 0 : 1)
            .overlay {
                if loading {
                    LoadingView()
                        .foregroundColor(.black)
                }
            }
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
            .disabled(loading)
    }
}
