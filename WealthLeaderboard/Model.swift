//
//  Model.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI
import Swizzle

class Model: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var photo: UIImage?
    @Published var allUsers: [User] = []
    
    init() {
        Task {
            do{
                let users: [User] = try await Swizzle.shared.get("allUserRanks")
                self.allUsers = users
            } catch {
                print(error)
            }
        }
    }
    
    var signedUp: Bool { photo != nil }
}
