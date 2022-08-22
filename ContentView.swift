//
//  ContentView.swift
//  Shared
//
//  Created by Karla Pangilinan on 7/17/22.
//

import SwiftUI

struct ContentView: View {
  // TODO: [learn iOS] (6) environment obj
  @EnvironmentObject var authViewModel: GoogleAuthenticationViewModel
  
  // MARK: - Picker
  @State private var isShowingPicker = false
  @State private var selectedImageUrl: NSURL = .init()
  // MARK: -

  var body: some View {
    // TODO: [learn iOS] (7) emit signout & disconnect
    VStack {
      Text("Hello, \(authViewModel.viewState.user?.profile?.givenName ?? "world")!")
        .padding()
      Text("Image Url: \(selectedImageUrl)")
        .padding()
      if authViewModel.viewState.user == nil {
        SignInView()
          .environmentObject(authViewModel)
      } else {
        Button("SIGN OUT") {
          authViewModel.emits(.signOut)
        }.padding()
        
        Button("DISCONNECT") {
          authViewModel.emits(.disconnect)
        }.padding()

        // MARK: - Picker
        Button("PICKER") {
          isShowingPicker = true
        }.padding()
        // MARK: -
        
        Button("UPLOAD") {
//          let fileURL = Bundle.main.url(forResource: "pixelated", withExtension: ".png")
          let fileURL = selectedImageUrl as URL
          GoogleDriveService.shared.uploadFileWithPermissions(
            name: "pixelated.png",
            fileURL: fileURL,
            mimeType: "image/png")
        }.padding()
        
        Button("SEARCH") {
          GoogleDriveService.shared.search()
        }.padding()
        
        Button("CREATE PERMISSION") {
          GoogleDriveService.shared.updatePermission()
        }.padding()
        
        Button("VIEW RECENTLY-UPLOADED FILE") {
          if let url = URL(string: "https://drive.google.com/file/d/1I8jdNleysnZzcg5-FeZk6yV0gIaB1WKf/view?usp=drivesdk") {
            UIApplication.shared.open(url)
          }
        }.padding()
      }
    }
    // MARK: - Picker
    .sheet(isPresented: $isShowingPicker) {
      PhotoPicker(imageUrl: $selectedImageUrl)
    }
    // MARK: -
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
