//
//  SeeMoneyView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI
import Kingfisher

struct SeeMoneyView: View {
    var user: User
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 10) {
                Circle()
                    .frame(width: 109, height: 109)
                    .foregroundColor(.white)
                    .overlay {
                        Color.clear
                            .overlay {
                                if let url = URL(string: user.photoURL) {
                                    KFImage(url)
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                            .clipShape(Circle())
                            .padding(3)
                    }
                    .background {
                        Circle()
                            .foregroundColor(.white)
                            .padding(4)
                            .shadow(color: .black.opacity(0.25), radius: 7.5, x: 0, y: 4)
                    }
                    .padding(10)
                
                Text(user.name)
                    .font(.large)
            }
            .drawingGroup()
            
            HStack {
                Image("lock")
                Text("Their balance is hidden")
                    .font(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12.5)
            .overlay {
                Capsule()
                    .stroke(lineWidth: 1.5)
            }
            
            Button("See how much money they have") {
            }
            .buttonStyle(WLButtonStyle())
        }
    }
}

struct SeeMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SeeMoneyView(user: .bezos)
        }
    }
}
