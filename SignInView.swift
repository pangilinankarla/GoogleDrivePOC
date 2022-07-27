//
//  SignInView.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 7/19/22.
//

import SwiftUI

struct SignInView: View {
  @EnvironmentObject var authViewModel: GoogleAuthenticationViewModel
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    VStack {
      HStack {
        VStack {
          // TODO: [learn iOS] () Add Sign in button
          GoogleSignInButton()
            .padding()
            .onTapGesture {
              // TODO: [learn iOS] () emit sign in
              authViewModel.emits(.signIn)
            }
          Button("sign in") {
            authViewModel.emits(.signIn)
          }
          #if os(iOS)
          .pickerStyle(.segmented)
          #endif
        }
      }
      Spacer()
    }
  }
}
