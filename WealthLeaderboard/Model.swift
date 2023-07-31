//
//  Model.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI
import SwizzleStorage

class Model: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var photo: UIImage?
    @Published var allUsers: [User] = []
    
    init() {
        Task {
            let users: [User] = try await Swizzle.shared.get("getAllUsersByRank")
            self.allUsers = users
        }
    }
    
    var signedUp: Bool { photo != nil }
}
