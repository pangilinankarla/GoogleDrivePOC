//
//  GoogleDrivePOCApp.swift
//  Shared
//
//  Created by Karla Pangilinan on 7/17/22.
//

import SwiftUI

@main
struct GoogleDrivePOCApp: App {
  // TODO: [learn iOS] (1) Add GoogleAuthenticationViewModel
  private var googleAuthViewModel: GoogleAuthenticationViewModel!

  init() {
    // TODO: [learn iOS] (2) init
    googleAuthViewModel = GoogleViewModelProvider.shared.provideGoogleAuthenticationViewModel()
  }

  var body: some Scene {
    WindowGroup {
      NavigationView {
        NavigationLink {
          ContentView()
            // TODO: [learn iOS] (5) environment obj
            .environmentObject(googleAuthViewModel)
        } label: {
          Text("Continue to Content View")
        }
      }
      .onOpenURL { url in
        // TODO: [learn iOS] (3) open URL
        googleAuthViewModel.handleUrl(url)
      }
      .onAppear {
        // TODO: [learn iOS] (4) on appear
        googleAuthViewModel.emits(.restorePreviousSignIn)
      }
    }
  }
}
