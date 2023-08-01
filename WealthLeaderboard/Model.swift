//
//  Model.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI
import Swizzle

@MainActor
class Model: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var photo: UIImage?
    @Published var balance: Int?
    @Published var allUsers: [User] = User.top
    
    var linkToken: String?
    
    @SwizzleStorage("user") var user: User?
    
    var rank: Int {
        get async throws {
            try await Swizzle.shared.get("rank")
        }
    }
        
    init() {
        Task {
            do {
                let users: [User] = try await Swizzle.shared.get("allUserRanks")
                allUsers = users
                let token: String = try await Swizzle.shared.get("plaidLinkToken")
                linkToken = token
            } catch {
                print(error)
            }
        }
    }
    
    var signedUp: Bool { photo != nil }
    
    func createUser() async throws {
        let url = try await Swizzle.shared.upload(image: photo ?? UIImage())
        let user = User(name: "\(firstName) \(lastName)", photoURL: url.absoluteString, balance: balance ?? 0)
        self.user = user
    }
}
