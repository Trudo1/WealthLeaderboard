//
//  WealthLeaderboardApp.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 6/29/23.
//

import SwiftUI

@main
struct WealthLeaderboardApp: App {
    @StateObject var contacts = ContactStore()
    @StateObject var model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contacts)
                .environmentObject(model)
                .preferredColorScheme(.light)
        }
    }
    
    init() {
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
    }
}
