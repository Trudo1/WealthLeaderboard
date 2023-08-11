//
//  Model.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import SwiftUI
import Contacts
import Swizzle

@MainActor
class Model: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var photo: UIImage?
    @Published var balance: Int?
    @Published var allUsers: [User] = []
    @Published var contactState: ContactState = .unrequested
    @Published var contacts: [User] = []
    
    var linkToken: String?
    
    @SwizzleData("users") var user: User?

    enum ContactState {
        case unrequested, enabled, unauthorized
    }
    
    var rank: Int {
        get async throws {
            try await Swizzle.shared.get("rank")
        }
    }
    
    var friendsRank: Int?
        
    init() {
        Swizzle.bindToUI(self)
        
        contactState = authStatus

        Task {
            do {
                try await fetchUsers()
                let token: String = try await Swizzle.shared.get("plaidLinkToken")
                linkToken = token
                try await fetchContacts()
            } catch {
                print(error)
            }
        }
    }
    
    var signedUp: Bool { user != nil }
    
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
    
    func createUser() async throws {
        let name = "\(firstName) \(lastName)"
        let url = try await Swizzle.shared.upload(image: photo ?? UIImage())
        let user = User(name: name, photoURL: url.absoluteString, balance: balance ?? 0, phone: phoneNumber.unformatted)
        
        self.user = user
        objectWillChange.send()
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
    
    func fetchUsers() async throws {
        allUsers = try await Swizzle.shared.get("allUserRanks")
    }
    
    func fetchContacts() async throws {
        let store = CNContactStore()
        let keysToFetch = [
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        let containers = try store.containers(matching: nil)
        var cnContacts: [CNContact] = []
        for container in containers {
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let results = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            cnContacts.append(contentsOf: results)
        }
        let phones = cnContacts.flatMap { $0.phoneNumbers.compactMap { $0.value.stringValue.unformatted } }
        let users: [User] = try await Swizzle.shared.postAndDecodeResponse("contactRanks", data: phones)
        let rank: Int = try await Swizzle.shared.post("myRankWithinContacts", data: phones)

        self.contacts = users
        self.friendsRank = rank
    }
}
