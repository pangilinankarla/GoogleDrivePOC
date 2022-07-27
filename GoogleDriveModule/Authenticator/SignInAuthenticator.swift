//
//  SignInAuthenticator.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 7/27/22.
//

import Combine
import Foundation

// TODO: before push ‼️ Clean up ‼️

protocol SignInAuthenticator: AnyObject {
  func handleUrl(_ url: URL)
  func signIn() -> Future<GoogleUser, AuthenticationError>
  func restorePreviousSignIn() -> Future<GoogleUser?, AuthenticationError>
  func signOut() -> Future<Void, Never>
  func disconnect() -> Future<Void, AuthenticationError>
}

enum AuthenticationResult {
  case signInResult(_ result: SignInResult)
  case signOutResult
  case disconnectResult(_ result: DisconnectResult)
  case restoreSignInResult(_ result: RestoreSignInResult)

  enum SignInResult {
    case loading
    case success(_ user: GoogleUser)
    case error(_ error: AuthenticationError)
  }

  enum DisconnectResult {
    case success
    case error(_ error: AuthenticationError)
  }

  enum RestoreSignInResult {
    case loading
    case success(_ user: GoogleUser?)
    case error(_ error: AuthenticationError)
  }
}

enum AuthenticationError: Error, CustomStringConvertible {
  case noRootViewController
  case nilSelf
  case custom(_ description: String)

  var description: String {
    switch self {
    case .noRootViewController:
      return "There is no root view controller!"
    case .nilSelf:
      return "nil self"
    case .custom(let desc):
      return desc
    }
  }
}
