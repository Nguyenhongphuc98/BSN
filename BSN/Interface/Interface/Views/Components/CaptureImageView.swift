//
//  CaptureImageView.swift
//  Interface
//
//  Created by Phucnh on 1/9/21.
//

import SwiftUI

enum ImageSourceType {
    case camera
    case gallery
}

struct CaptureImageView {
    
    @Binding var isShown: Bool
    
    var source: ImageSourceType = .gallery
    
    var didSelect: ((UIImage) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = self.source == .camera ? .camera : .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var parent : CaptureImageView
    
    init(parent : CaptureImageView) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        self.parent.didSelect?(unwrapImage)
        self.parent.isShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parent.isShown = false
    }
}
