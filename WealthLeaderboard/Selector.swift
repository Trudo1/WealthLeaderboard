//
//  Selector.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

struct Selector: View {
    @Binding var selection: ContentView.Page
    
    @State private var width: CGFloat = 0
    
    var x: CGFloat {
        switch selection {
        case .global:
            return 0
        case .friends:
            return width
        }
    }
        
    var body: some View {
        HStack {
            Button("Global list") {
                withAnimation {
                    selection = .global
                }
            }
            .frame(maxWidth: .infinity)
            .disabled(selection == .global)
            
            Button("Friends list") {
                withAnimation {
                    selection = .friends
                }
            }
            .frame(maxWidth: .infinity)
            .disabled(selection == .friends)
        }
        .padding(.vertical, 6)
        .background(alignment: .leading) {
            Capsule()
                .foregroundColor(.wlGreen)
                .frame(width: width)
                .offset(x: x)
                .animation(.interpolatingSpring(stiffness: 500, damping: 31), value: x)
        }
        .background {
            GeometryReader { g in
                Color.clear
                    .onAppear {
                        width = g.size.width / 2
                    }
            }
        }
        .foregroundColor(.primary)
        .font(.small)
    }
}

struct Selector_Previews: PreviewProvider {
    static var previews: some View {
        Selector(selection: .constant(.friends))
    }
}
