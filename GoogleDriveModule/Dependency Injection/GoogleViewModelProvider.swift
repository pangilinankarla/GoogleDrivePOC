final class GoogleViewModelProvider {
  static let shared = GoogleViewModelProvider()

  private init() {}

  func provideGoogleAuthenticationViewModel() -> GoogleAuthenticationViewModel {
    GoogleAuthenticationViewModel(GoogleSignInAuthenticator.shared)
  }
}
