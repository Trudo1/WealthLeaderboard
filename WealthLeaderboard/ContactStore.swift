//
//  ContactStore.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import Contacts

class ContactStore: ObservableObject {
    enum ContactState {
        case unrequested, enabled, unauthorized
    }
    
    @Published var contactState: ContactState = .unrequested
    
    init() {
        contactState = authStatus
    }
    
    func requestPermission() async -> Bool {
        let store = CNContactStore()
        do {
            try await store.requestAccess(for: .contacts)
            return true
        } catch {
            print("Error requesting contacts permission: \(error.localizedDescription)")
            return false
        }
    }
    
    var authStatus: ContactState {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .authorized:
            return .enabled
        case .denied:
            return .unauthorized
        case .notDetermined:
            return .unrequested
        case .restricted:
            return .unauthorized
        @unknown default:
            return .unauthorized
        }
    }
}
