//
//  AnyTransition+forward.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/31/23.
//

import SwiftUI

extension AnyTransition {
    static let forward = AnyTransition
        .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    static let back = AnyTransition
        .asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .trailing)
        )
}
