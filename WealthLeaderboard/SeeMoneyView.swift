//
//  SeeMoneyView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI
import Kingfisher

struct SeeMoneyView: View {
    @State var purchased = false
    @State var loading = false
    
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
                if !purchased {
                    Image("lock")
                    Text("Their balance is hidden")
                } else {
                    Text("Bank balance:")
                    Spacer()
                    Text(user.balance.dollarFormat)
                }
            }
            .drawingGroup()
            .padding(.horizontal, 22)
            .font(.medium)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12.5)
            .overlay {
                Capsule()
                    .stroke(lineWidth: 1.5)
            }
            
            if !purchased {
                Button("See how much money they have") {
                    loading = true
                    IAPHandler.shared.fetchAvailableProducts { products in
                        print("fetching")
                        guard let product = products.first else {
                            print("can't find product")
                            loading = false
                            return
                        }
                        print("product: \(product)")
                        IAPHandler.shared.purchase(product: product) { type, product, transaction in
                            print("purchasing")
                            switch type {
                            case .purchased:
                                purchased = true
                            default:
                                return
                            }
                            loading = false
                        }
                    }
                }
                .buttonStyle(WLButtonStyle(loading: $loading))
                .disabled(loading)
            }
        }
        .onDisappear {
            purchased = false
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
