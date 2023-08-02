//
//  WealthLeaderboardApp.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 6/29/23.
//

import SwiftUI
import Swizzle

@main
struct WealthLeaderboardApp: App {
    @StateObject var model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .preferredColorScheme(.light)
                .tint(.wlGreen)
        }
    }
    
    init() {
        Swizzle.shared.configure(projectId: "YourProjectID")
    }
}
