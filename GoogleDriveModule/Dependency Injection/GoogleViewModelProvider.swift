final class GoogleViewModelProvider {
  static let shared = GoogleViewModelProvider()

  private init() {}

  func provideGoogleAuthenticationViewModel() -> GoogleAuthenticationViewModel {
    let authenticator = GoogleSignInAuthenticator.shared
    let googleDriveAuthorizer = GoogleDriveService.shared
    authenticator.setGoogleDriveAuthorizer(googleDriveAuthorizer)

    return GoogleAuthenticationViewModel(authenticator)
  }

  func provideFileUploadViewModel() -> GoogleAuthenticationViewModel {
    let authenticator = GoogleSignInAuthenticator.shared
    let googleDriveAuthorizer = GoogleDriveService.shared
    authenticator.setGoogleDriveAuthorizer(googleDriveAuthorizer)
    
    return GoogleAuthenticationViewModel(authenticator)
  }
}
