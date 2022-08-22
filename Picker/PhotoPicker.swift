//
//  PhotoPicker.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 8/18/22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
  @Binding var imageUrl: NSURL
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    // No operation
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(photoPicker: self)
  }

  final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private let photoPicker: PhotoPicker

    init(photoPicker: PhotoPicker) {
      self.photoPicker = photoPicker
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      // TODO: Replace with PHPicker
      let imageUrl = info[.imageURL] as? NSURL
      let imageName = imageUrl?.lastPathComponent
      print("IMAGE URL : \(String(describing: imageUrl))")
      print("IMAGE NAME : \(String(describing: imageName))")
      
      if imageUrl != nil {
        photoPicker.imageUrl = imageUrl!
      }
      
      picker.dismiss(animated: true)
    }
  }
}
