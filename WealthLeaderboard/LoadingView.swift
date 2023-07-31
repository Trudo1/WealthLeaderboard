//
//  LoadingView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        LottieView(name: "loading")
            .frame(width: 56, height: 56)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
