//
//  LinkBankView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

struct CardView<CardContent: View>: View {
    @State private var photoHeight: CGFloat = 0
    
    var showMoney: Bool
    var topText: String
    var content: CardContent
    
    init(showMoney: Bool = false, topText: String, @ViewBuilder content: () -> CardContent) {
        self.showMoney = showMoney
        self.topText = topText
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 28) {
                if showMoney {
                    Color.clear
                        .frame(height: photoHeight)
                        .overlay {
                            photo
                                .offset(y: -photoHeight / 2)
                        }
                }
                
                if showMoney {
                    Image(topText)
                        .padding(.top, -5)
                } else {
                    Image(topText)
                        .padding(.top, 26)
                }
                
                content
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 21)
            .multilineTextAlignment(.center)
            .background {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(40, corners: [.topLeft, .topRight])
                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity)
        .transition(.move(edge: .bottom))
        .zIndex(1)
    }
    
    var photo: some View {
        ZStack {
            Image("friends.background")
                .background {
                    Circle()
                        .foregroundColor(.white)
                        .padding(15)
                        .shadow(color: .black.opacity(0.25), radius: 7.5, x: 0, y: 4)
                }
            Image("cash")
                .offset(y: -3)
        }
        .background {
            GeometryReader { g in
                Color.clear
                    .onAppear {
                        photoHeight = g.size.height / 2
                    }
            }
        }
    }
}

struct SheetOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(topText: "link.bank") { }
    }
}
