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

  var body: some View {
    // TODO: [learn iOS] (7) emit signout & disconnect
    Text("Hello, \(authViewModel.viewState.user?.profile?.givenName ?? "world")!")
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
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
