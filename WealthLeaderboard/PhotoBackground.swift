//
//  PhotoBackground.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

struct PhotoBackground: View {
    var body: some View {
        Image("friends.background")
            .background {
                Circle()
                    .foregroundColor(.white)
                    .padding(16)
                    .shadow(color: .black.opacity(0.25), radius: 7.5, x: 0, y: 4)
            }
    }
}

struct PhotoBackground_Previews: PreviewProvider {
    static var previews: some View {
        PhotoBackground()
    }
}
