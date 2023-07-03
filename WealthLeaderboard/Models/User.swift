//
//  User.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import Foundation

struct User: Identifiable, Hashable {
    var id =  UUID()
    var name: String
    var photoURL: String
    var balance: Int
}

extension [User] {
    var second: User? {
        self.indices.contains(1) ? self[1] : nil
    }
    
    var third: User? {
        self.indices.contains(2) ? self[2] : nil
    }
}

extension User {
    static let musk = User(name: "Elon Musk", photoURL: "https://upload.wikimedia.org/wikipedia/commons/3/34/Elon_Musk_Royal_Society_%28crop2%29.jpg", balance: 10)
    static let anault = User(name: "Bernard Arnault", photoURL: "https://upload.wikimedia.org/wikipedia/commons/d/de/Bernard_Arnault_%283%29_-_2017_%28cropped%29.jpg", balance: 9)
    static let bezos = User(name: "Jeff Bezos", photoURL: "https://m.media-amazon.com/images/M/MV5BYTNlOGZhYzgtMmE3OC00Y2NiLWFhNWQtNzg5MjRhNTJhZGVmXkEyXkFqcGdeQXVyNzg5MzIyOA@@._V1_.jpg", balance: 8)
    static let ellison = User(name: "Larry Ellison", photoURL: "https://upload.wikimedia.org/wikipedia/commons/0/00/Larry_Ellison_picture.png", balance: 7)
    static let gates = User(name: "Bill Gates", photoURL: "https://upload.wikimedia.org/wikipedia/commons/a/a8/Bill_Gates_2017_%28cropped%29.jpg", balance: 6)
    static let buffett = User(name: "Warren Buffett", photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Warren_Buffett_at_the_2015_SelectUSA_Investment_Summit_%28cropped%29.jpg/640px-Warren_Buffett_at_the_2015_SelectUSA_Investment_Summit_%28cropped%29.jpg", balance: 5)
    static let balmer = User(name: "Steve Ballmer", photoURL: "https://upload.wikimedia.org/wikipedia/commons/4/44/Steve_Ballmer_2014.jpg", balance: 4)
    static let slim = User(name: "Carlos Slim", photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Carlos_Slim_%2845680472234%29_%28cropped%29.jpg/1200px-Carlos_Slim_%2845680472234%29_%28cropped%29.jpg", balance: 3)
    static let zuck = User(name: "Mark Zuckerberg", photoURL: "https://upload.wikimedia.org/wikipedia/commons/1/18/Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg", balance: 2)
    static let page = User(name: "Larry Page", photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Larry_Page_in_the_European_Parliament%2C_17.06.2009_%28cropped%29.jpg/800px-Larry_Page_in_the_European_Parliament%2C_17.06.2009_%28cropped%29.jpg", balance: 1)
    
    static let top: [User] = [
        .musk,
        .anault,
        .bezos,
        .ellison,
        .gates,
        .buffett,
        .balmer,
        .slim,
        .zuck,
        .page,
    ]
}
