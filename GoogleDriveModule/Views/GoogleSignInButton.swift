//
//  GoogleSignInButton.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 7/27/22.
//

import GoogleSignIn
import SwiftUI

struct GoogleSignInButton: UIViewRepresentable {
  @Environment(\.colorScheme) var colorScheme

  private var button = GIDSignInButton()

  func makeUIView(context: Context) -> GIDSignInButton {
    button.colorScheme = colorScheme == .dark ? .dark : .light
    button.style = .wide
    return button
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    button.colorScheme = colorScheme == .dark ? .dark : .light
    button.style = .wide
  }
}
