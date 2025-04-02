//
//  ImagePicker.swift
//  zala
//
//  Created by Kyle Carriedo on 4/15/24.
//

import Foundation
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @Binding var selectedImage: UIImage

        
    var actionTapped: ((_ img:UIImage) -> Void)?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                parent.actionTapped?(image)
            } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.actionTapped?(image)
            }
            parent.dismiss()
        }

    }
}


//
//extension ImagePicker {
////    var actionTapped: ((_ img:UIImage) -> Void)?
//    func actionTapped(action: @escaping ((_ img:UIImage) -> Void)) -> ImagePicker {
//        ImagePicker(actionTapped: action)
//    }
//}
