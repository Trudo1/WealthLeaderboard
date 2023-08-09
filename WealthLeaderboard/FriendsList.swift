//
//  FriendsList.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI
import Kingfisher

struct FriendsList: View {
    @EnvironmentObject var model: Model
    
    @Binding var selectedUser: User?
    
    var users: [User] {
        model.contacts
    }
    
    
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
        ScrollView {
            LazyVStack(spacing: 0) {
                first3
                
                ForEach(Array(users.dropFirst(3).enumerated()), id: \.element) { offset, user in
                    rowPhoto(of: user, index: offset)
                }
            }
            .padding(.top, 20)
        }
    }
        
    var first3: some View {
        HStack(alignment: .bottom) {
            if let second = users.second {
                topPhoto(of: second, index: 1)
            }
            if let first = users.first {
                topPhoto(of: first, index: 0)
            }
            if let third = users.third {
                topPhoto(of: third, index: 2)
            }
        }
        .padding(.horizontal, 21)
        .padding(.bottom, 24)
    }
    
    func rowPhoto(of user: User, index: Int) -> some View {
        Button {
            selectedUser = user
        } label: {
            HStack(spacing: 21) {
                Text("\(index + 4)")
                    .frame(minWidth: 22)
                Color.clear
                    .frame(width: 48, height: 48)
                    .overlay {
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
        }
        .contentShape(Rectangle())
        .buttonStyle(RowButtonStyle())
    }
        
    @ViewBuilder
    func topPhoto(of user: User, index: Int) -> some View {
        let frame: CGFloat = index == 0 ? 98 : 81
        
        Button {
            selectedUser = user
        } label: {
            VStack(spacing: 17) {
                if let url = URL(string: user.photoURL) {
                    Color.clear
                        .frame(width: frame, height: frame)
                        .overlay {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                        }
                        .clipShape(Circle())
                        .overlay(alignment: .topLeading) {
                            Circle()
                                .frame(width: 38)
                                .foregroundColor(.white)
                                .overlay {
                                    Circle()
                                        .foregroundColor(color(at: index))
                                        .padding(4)
                                    Text("\(index + 1)")
                                        .foregroundColor(.white)
                                        .font(.medium)
                                }
                                .offset(x: -5, y: -5)
                        }
                }
                Text(user.name.replacingOccurrences(of: " ", with: "\n"))
                    .font(.large)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.black)
        }
    }
        
    func color(at index: Int) -> Color {
        switch index {
        case 0:
            return .color(r: 255, g: 184, b: 0)
        case 1:
            return .color(r: 255, g: 142, b: 37)
        case 2:
            return .color(r: 255, g: 89, b: 37)
        default:
            return .primary
        }
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
        FriendsList(selectedUser: .constant(.anault))
            .environmentObject(Model())
    }
}
