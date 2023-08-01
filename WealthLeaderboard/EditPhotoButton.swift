//
//  EditPhotoButton.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/31/23.
//

import SwiftUI

struct EditPhotoButton: View {
    var photo: UIImage
    
    var body: some View {
        Circle()
            .foregroundColor(.white)
            .frame(width: 109, height: 109)
            .shadow(color: .black.opacity(0.25), radius: 7.5, x: 0, y: 4)
            .overlay {
                Color.clear
                    .overlay(alignment: .bottomTrailing) {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Rectangle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .clipShape(RoundedCorner(radius: 16, corners: .topLeft))
                            .offset(x: 3, y: 3)
                            .overlay {
                                Image("pencil")
                                    .offset(x: -2, y: -2)
                            }
                    }
                    .clipShape(Circle())
                    .padding(3)
            }
    }
}

struct EditPhotoButton_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotoButton(photo: UIImage(named: "AppIcon") ?? UIImage())
    }
}
