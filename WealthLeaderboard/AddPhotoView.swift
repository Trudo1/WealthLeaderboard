//
//  AddPhotoView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/31/23.
//

import SwiftUI
import PhotosUI

struct AddPhotoView: UIViewControllerRepresentable {
    @Binding var photo: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: AddPhotoView

        init(_ parent: AddPhotoView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider else {
                return
            }
            
            guard provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) else {
                return
            }

            provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                if let url = url {
                    DispatchQueue.global(qos: .userInitiated).async {
                        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.parent.photo = image
                            }
                        }
                    }
                }
            }
        }

    }
}

struct AddPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotoView(photo: .constant(nil))
    }
}
