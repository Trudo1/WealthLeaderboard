//
//  PhoneTextField.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 8/2/23.
//

import PhoneNumberKit
import SwiftUI

struct PhoneNumberField: UIViewRepresentable {
    @Binding var phoneNumber: String
    
    func makeUIView(context: Context) -> PhoneNumberTextField {
        let textField = PhoneNumberTextField()
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.delegate = context.coordinator
        textField.font = UIFont(name: "LabGrotesque-Medium", size: 18)
        textField.textAlignment = .center
        return textField
    }
    
    func updateUIView(_ uiView: PhoneNumberTextField, context: Context) {
        uiView.text = phoneNumber
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PhoneNumberField
        
        init(_ parent: PhoneNumberField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.phoneNumber = textField.text ?? ""
        }
    }
}
