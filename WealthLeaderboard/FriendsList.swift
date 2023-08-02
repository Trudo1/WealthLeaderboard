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
        if model.signedUp {
            if !(model.authStatus == .enabled) {
                buildContent(image: "enable.contacts", text: "Enable contacts to see where your friends rank amongst the wealth leaderboard")
            } else {
                if model.contacts.isEmpty {
                    buildContent(image: "no.contacts", text: "")
                } else {
                    contactsList
                }
            }
        } else {
            buildContent(image: "sign.up", text: "Sign up to see where your friends rank amongst the wealth leaderboard")
        }
    }
    
    var contactsList: some View {
        Text("Coming soon")
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsList()
            .environmentObject(Model())
    }
}
