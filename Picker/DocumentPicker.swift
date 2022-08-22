//
//  DocumentPicker.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 8/22/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
  @Binding var documentURL: NSURL

  func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
//    let picker = UIDocumentPickerViewController(documentTypes: [], in: .open) // deprecated
    let supportedTypes: [UTType] = [.item]
    let picker = UIDocumentPickerViewController(
      forOpeningContentTypes: supportedTypes,
      asCopy: true)
    picker.allowsMultipleSelection = false
    picker.shouldShowFileExtensions = true
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    // Not implemented
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(documentPicker: self)
  }
  

  final class Coordinator: NSObject, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    private let documentPicker: DocumentPicker
    
    init(documentPicker: DocumentPicker) {
      self.documentPicker = documentPicker
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      guard let fileUrl = urls.first as? NSURL else {
        controller.dismiss(animated: true)
        return
      }
      
      print("URL : \(String(describing: fileUrl))")
      documentPicker.documentURL = fileUrl
      controller.dismiss(animated: true)
    }
  }
}
