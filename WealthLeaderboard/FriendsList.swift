//
//  FriendsList.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

struct FriendsList: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        buildContent(image: "sign.up", text: "Sign up to see where your friends rank amongst the wealth leaderboard")
//        buildContent(image: "enable.contacts", text: "Enable contacts to see where your friends rank amongst the wealth leaderboard")
    }
    
    func buildContent(image: String, text: String) -> some View {
        VStack(spacing: 28) {
            ZStack {
                PhotoBackground()
                Image("friends")
            }
            Image(image)
            
            Text(text)
                .font(.large)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 5)
        }
        .frame(maxHeight: .infinity)
    }
}

struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsList()
            .environmentObject(Model())
    }
}
