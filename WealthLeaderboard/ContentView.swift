//
//  ContentView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 6/29/23.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var contacts: ContactStore
    
    @State private var page: Page = .global
    @State private var isPresentingSignUp = false
    
    @State private var userCard: User?
    @State private var globalRank: Int?
    @State private var friendsRank: Int?
    var rank: Int? {
        switch page {
        case .friends:
            return friendsRank
        case .global:
            return globalRank
        }
    }
    
    enum Page {
        case global, friends
    }
    
    @State private var getStartedPage = GetStarted.link
    
    enum GetStarted {
        case link, first, last, picture
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
                OnboardingView(showing: $isPresentingSignUp, page: $getStartedPage)
                    .transition(.move(edge: .bottom))
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
        .tabViewStyle(.page(indexDisplayMode: .never))
        .refreshable {
            do {
                globalRank = try await model.rank
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @ViewBuilder
    var button: some View {
        if let user = model.user {
            if page == .friends && !(contacts.contactState == .enabled) {
                Text("hlwrld")
            } else {
                HStack(spacing: 21) {
                    Text("\(rank ?? 0)")
                        .opacity(rank == nil ? 0 : 1)
                        .overlay {
                            if rank == nil {
                                LoadingView()
                            }
                        }

                    Color.clear
                        .frame(width: 48, height: 48)
                        .overlay(alignment: .top) {
                            if let url = URL(string: user.photoURL) {
                                KFImage(url)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .clipShape(Circle())
                    Text(user.name)
                    Spacer()
                }
                .font(.large)
                .padding(.vertical, 12)
                .padding(.horizontal, 22)
                .task {
                    do {
                        globalRank = try await model.rank
                    } catch {
                        print("Error getting user rank")
                    }
                }
            }
        } else {
            Button(buttonText) {
                isPresentingSignUp = true
            }
            .buttonStyle(WLButtonStyle())
            .padding(24)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
