//
//  View+EdgeShadow.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

extension View {
    func edgeShadow(show: Bool, top: Bool = true, inset: CGFloat = 0) -> some View {
        self
            .overlay {
                VStack(spacing: 0) {
                    if !top { Spacer() }
                    NavBarShadow()
                        .rotation3DEffect(top ? .zero : .degrees(180), axis: (x: 1, y: 0, z: 0))
                    if top { Spacer() }
                }
                .opacity(show ? 1 : 0)
                .offset(y: top ? inset : -inset)
                .ignoresSafeArea(.keyboard)
            }
    }
}

struct NavBarShadow: View {
    var body: some View {
        Color.clear
            .frame(maxHeight: .infinity)
            .overlay(alignment: .top) {
                Rectangle()
                    .offset(y: -3)
                    .frame(height: 3)
                    .shadow(color: .black.opacity(0.08), radius: 2)
            }
            .clipped()
    }
}
