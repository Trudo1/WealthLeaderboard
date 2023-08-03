//
//  ContentView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 6/29/23.
//

import SwiftUI
import Kingfisher
import Swizzle

struct ContentView: View {
    @EnvironmentObject var model: Model
    @ObservedObject var user: SwizzleModel<User> = SwizzleModel("users")

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
    
    let productLink = URL(string: "https://testflight.apple.com/join/CGNlyZDN")!
    
    enum Page {
        case global, friends
    }
    
    @State private var getStartedPage = GetStarted.link
    
    enum GetStarted {
        case link, first, last, phone, picture
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
                user.refresh()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @ViewBuilder
    var button: some View {
        if var user = user.object {
            HStack(spacing: 21) {
                Text("\(rank ?? 0)")
                    .opacity(rank == nil ? 0 : 1)
                    .overlay {
                        if rank == nil {
                            LoadingView()
                        }
                    }
                    .frame(minWidth: 22)

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
            .onTapGesture {
                user.name = "a"
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
            .opacity(page == .friends && model.contacts.isEmpty ? 0 : 1)
            .overlay {
                if page == .friends {
                    if !(model.contactState == .enabled) {
                        Button("Enable Contacts") {
                            Task {
                                await model.requestPermission()
                            }
                        }
                        .buttonStyle(WLButtonStyle())
                        .padding()
                    } else if model.contacts.isEmpty {
                        ShareLink(item: productLink) {
                            Text("Invite your friends")
                                .font(.medium)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundColor(.wlGreen)
                                }
                        }
                        .padding()
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
