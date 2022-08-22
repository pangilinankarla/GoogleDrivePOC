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

  private lazy var configuration: GIDConfiguration = {
    return GIDConfiguration(clientID: GoogleConstant.iosClientId)
  }()

  private var googleDriveAuthorizer: GoogleDriveAuthorizer!

  private init() {}

  func setGoogleDriveAuthorizer(_ authorizer: GoogleDriveAuthorizer) {
    googleDriveAuthorizer = authorizer
  }
}

// MARK: SignInAuthenticator conformance
extension GoogleSignInAuthenticator: SignInAuthenticator {
  func handleUrl(_ url: URL) {
    GIDSignIn.sharedInstance.handle(url)
  }

  /// Uses additional scopes (redundant prompts)
/*
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

//      GIDSignIn.sharedInstance.signIn(
//        with: self.configuration,
//        presenting: rootViewController
//      ) { user, error in
//        guard let user = user else {
//          print("Error! \(String(describing: error))")
//          promise(.failure(.custom(String(describing: error))))
//          return
//        }
//      promise(.success(GoogleUser(user)))

      GIDSignIn.sharedInstance.signIn(
        with: self.configuration,
        presenting: rootViewController
      ) { user, error in
        guard let user = user else {
          print("Error! \(String(describing: error))")
          promise(.failure(.custom(String(describing: error))))
          return
        }

//        promise(.success(GoogleUser(user)))
        print("Authenticate successfully")
        // Check which scopes have been granted
        let grantedScopes = user.grantedScopes
        print("scopes: \(String(describing: grantedScopes))")
        
        // Request additional scopes
        if grantedScopes == nil || !grantedScopes!.contains(GoogleConstant.driveScope) {
          GIDSignIn.sharedInstance.addScopes(
            [GoogleConstant.driveScope],
            presenting: rootViewController)
          { [weak self] user, error in
            
            if let error = error {
              print("add scope failed, \(error), \(error.localizedDescription)")
              promise(.failure(.custom(String(describing: error))))
            }
            
            guard let user = user else { return }
            
            DispatchQueue.main.async {
              print("userDidSignInGoogle")
//              self?.updateScreen()
            }
            
            // Check if the user granted access to the scopes you requested.
            if let scopes = user.grantedScopes,
               scopes.contains(GoogleConstant.driveScope) {
              print("Scope added")
              // 3
//              self?.createGoogleDriveService(user: user)
              promise(.success(GoogleUser(user)))
            }
          }
        } else if grantedScopes!.contains(GoogleConstant.driveScope) {
          promise(.success(GoogleUser(user)))
        }
      }
    }
  }
*/

  /// Sign In with scope (checkbox)
  // TODO: ❗️check scopes & show auth❗️
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
        presenting: rootViewController,
        hint: nil,
        additionalScopes: [GoogleConstant.driveScope]
      ) { user, error in
        guard let user = user else {
          print("Error! \(String(describing: error))")
          
//          GoogleDriveService.shared.setAuthorizer(nil)
          self.googleDriveAuthorizer.setAuthorizer(nil)
          
          promise(.failure(.custom(String(describing: error))))
          return
        }

        // Check if the user granted access to the scopes you requested.
        if let scopes = user.grantedScopes,
           scopes.contains(GoogleConstant.driveScope) {
          print("Scope added")
          // 3
          //              self?.createGoogleDriveService(user: user)
        }
        
        /*
         Once a user successfully signs in, you can set the authorizer property on the GTLRDriveService.
         This ensures that all requests made by the service to the Google Drive API
         include any required authentication headers and values (e.g., access token, refresh token).
         */
        // Include authorization headers/values with each Drive API request.
        // self.googleDriveService.authorizer = user.authentication.fetcherAuthorizer()
        GoogleDriveService.shared.setAuthorizer(user.authentication.fetcherAuthorizer())
        
        // set service type to GoogleDrive
//        let service = GTLRDriveService()
//        service.authorizer = user.authentication.fetcherAuthorizer()
        
        // dependency inject
//        stateManager.googleAPIs = GoogleDriveAPI(service: service)
        
        user.authentication.do { [weak self] authentication, error in
          guard error == nil else { return }
          guard let authentication = authentication else { return }
          
          // Get the access token to attach it to a REST or gRPC request.
          // let accessToken = authentication.accessToken
          
          // Or, get an object that conforms to GTMFetcherAuthorizationProtocol for
          // use with GTMAppAuth and the Google APIs client library.
//          GoogleDriveService.shared.setAuthorizer(authentication.fetcherAuthorizer())
          self?.googleDriveAuthorizer.setAuthorizer(authentication.fetcherAuthorizer())
//          let service = GTLRDriveService()
//          service.authorizer = authentication.fetcherAuthorizer()
          
          // dependency inject
//          self?.stateManager.googleAPIs = GoogleDriveAPI(service: service)
          
//          let vc = GoogleDriveViewController()
//          vc.stateManager = self?.stateManager
//          self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        promise(.success(GoogleUser(user)))
      }
    }
  }

  func restorePreviousSignIn() -> Future<GoogleUser?, AuthenticationError> {
    return Future { promise in
      GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
        if let user = user {
          
          user.authentication.do { [weak self] authentication, error in
            guard error == nil else { return }
            guard let authentication = authentication else { return }
            
            // Get the access token to attach it to a REST or gRPC request.
            // let accessToken = authentication.accessToken
            
            // Or, get an object that conforms to GTMFetcherAuthorizationProtocol for
            // use with GTMAppAuth and the Google APIs client library.
//            GoogleDriveService.shared.setAuthorizer(authentication.fetcherAuthorizer())
            self?.googleDriveAuthorizer.setAuthorizer(authentication.fetcherAuthorizer())
            //          let service = GTLRDriveService()
            //          service.authorizer = authentication.fetcherAuthorizer()
            
            // dependency inject
            //          self?.stateManager.googleAPIs = GoogleDriveAPI(service: service)
            
            //          let vc = GoogleDriveViewController()
            //          vc.stateManager = self?.stateManager
            //          self?.navigationController?.pushViewController(vc, animated: true)
          }
          
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

  // removes granted scopes
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
