//
//  PlaidView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/31/23.
//

import SwiftUI
import LinkKit
import Swizzle

struct PlaidView: View {
    @EnvironmentObject var model: Model
    @SwiftUI.Environment(\.dismiss) var dismiss
    
    var body: some View {
        if let token = model.linkToken {
            let createResult = createHandler(with: token)
            switch createResult {
            case .failure(let createError):
                Text("Link Creation Error: \(createError.localizedDescription)")
                    .font(.title2)
            case .success(let handler):
                LinkController(handler: handler)
            }
        } else {
            Text("Error getting link token")
        }
    }
    
    private func createHandler(with token: String) -> Result<Handler, Plaid.CreateError> {
        let configuration = createLinkTokenConfiguration(with: token)
        return Plaid.create(configuration)
    }
    
    private func createLinkTokenConfiguration(with token: String) -> LinkTokenConfiguration {

        var linkConfiguration = LinkTokenConfiguration(token: token) { success in
            Task{
                print("Exchanging Plaid Token")
                try await Swizzle.shared.post("exchangePlaidToken", data: success)
            }
            dismiss()
        }

        linkConfiguration.onExit = { exit in
            if let error = exit.error {
                print("exit with \(error)\n\(exit.metadata)")
            } else {
                print("exit with \(exit.metadata)")
            }
            dismiss()
        }

        linkConfiguration.onEvent = { event in
            print("Link Event: \(event)")
        }

        return linkConfiguration
    }
}

struct PlaidView_Previews: PreviewProvider {
    static var previews: some View {
        PlaidView()
    }
}
