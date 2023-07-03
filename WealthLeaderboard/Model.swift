//
//  Model.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI

class Model: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var photo: UIImage?
    
    var signedUp: Bool {
        photo != nil
    }
}
