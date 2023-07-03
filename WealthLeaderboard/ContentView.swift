//
//  ContentView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 6/29/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var contacts: ContactStore
    
    @State private var page: Page = .global
    @State private var isPresentingSignUp = false
    
    @State private var userCard: User?
    
    enum Page {
        case global, friends
    }
    
    var buttonText: String {
        "See where you rank"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image("header")
                .padding(.top, 20)
            
            Selector(selection: $page)
                .padding([.horizontal, .top], 28)
                .padding(.bottom, 20)
            
            tabView
            button
        }
        .overlay {
            if isPresentingSignUp {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresentingSignUp = false
                    }

                CardView(showMoney: true, topText: "link.bank") {
                    linkContent
                }
            }
        }
        .animation(.spring(), value: isPresentingSignUp)
        .overlay {
            if let user = userCard {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        userCard = nil
                    }

                CardView(topText: "view.money") {
                    SeeMoneyView(user: user)
                }
            }
        }
        .animation(.spring(), value: userCard)
    }
    
    var tabView: some View {
        TabView(selection: $page) {
            RankList(selectedUser: $userCard)
                .edgeShadow(show: true)
                .edgeShadow(show: true, top: false)
                .tag(Page.global)
            
            FriendsList()
                .edgeShadow(show: true)
                .tag(Page.friends)
        }
        .tabViewStyle(.page)
    }
    
    var button: some View {
        Button(buttonText) {
//            switch page {
//            case .global:
                isPresentingSignUp = true
//            case .friends:
//                Task {
//                    await contacts.requestPermission()
//                }
//            }
        }
        .buttonStyle(WLButtonStyle())
        .padding(24)
    }
    
    @ViewBuilder
    var linkContent: some View {        
        Text("Link your balance to see where your wealth ranks on the leaderboard")
            .font(.large)
            .padding(.horizontal, 11)
        
        Text("Don’t worry, your bank balance will be hidden from other users")
            .font(.sm)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background {
                Capsule()
                    .stroke(lineWidth: 1.3)
            }
        
        Button("Continue") {
            
        }
        .buttonStyle(WLButtonStyle())
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
