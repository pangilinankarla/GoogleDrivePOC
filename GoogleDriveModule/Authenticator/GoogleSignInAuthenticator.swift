//
//  GoogleSignInAuthenticator.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 7/18/22.
//

import Combine
import GoogleSignIn

final class GoogleSignInAuthenticator {
  static let shared = GoogleSignInAuthenticator()

  private init() {}

  private lazy var configuration: GIDConfiguration = {
    return GIDConfiguration(clientID: GoogleConstant.iosClientId)
  }()
}

// MARK: SignInAuthenticator conformance
extension GoogleSignInAuthenticator: SignInAuthenticator {
  func handleUrl(_ url: URL) {
    GIDSignIn.sharedInstance.handle(url)
  }

  func signIn() -> Future<GoogleUser, AuthenticationError> {
    return Future { [weak self] promise in
      guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
        print("There is no root view controller!")
        promise(.failure(.noRootViewController))
        return
      }

      guard let self = self else {
        promise(.failure(.nilSelf))
        return
      }

      GIDSignIn.sharedInstance.signIn(
        with: self.configuration,
        presenting: rootViewController
      ) { user, error in
        guard let user = user else {
          print("Error! \(String(describing: error))")
          promise(.failure(.custom(String(describing: error))))
          return
        }

        promise(.success(GoogleUser(user)))
      }
    }
  }

  func restorePreviousSignIn() -> Future<GoogleUser?, AuthenticationError> {
    return Future { promise in
      GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
        if let user = user {
          promise(.success(GoogleUser(user)))
        } else if let error = error {
          print("There was an error restoring the previous sign-in: \(error)")
          promise(.failure(.custom(String(describing: error))))
        } else {
          print("User logged out")
          promise(.success(nil))
        }
      }
    }
  }

  func signOut() -> Future<Void, Never> {
    return Future { promise in
      GIDSignIn.sharedInstance.signOut()
      promise(.success(()))
    }
  }

  func disconnect() -> Future<Void, AuthenticationError> {
    return Future { promise in
      GIDSignIn.sharedInstance.disconnect { error in
        if let error = error {
          print("Encountered error disconnecting scope: \(error).")
          promise(.failure(.custom(String(describing: error))))
        } else {
          promise(.success(()))
        }
      }
    }
  }
}
