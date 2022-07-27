struct GoogleAuthenticationViewState: Equatable {
  var user: GoogleUser? = nil
  var authenticationState: AuthenticationState = .signedOut
  var error: Error? = nil

  static func idle() -> GoogleAuthenticationViewState {
    return GoogleAuthenticationViewState()
  }

  static func == (lhs: GoogleAuthenticationViewState, rhs: GoogleAuthenticationViewState) -> Bool {
    return lhs.user == rhs.user
      && lhs.authenticationState == rhs.authenticationState
      && lhs.error?.localizedDescription == rhs.error?.localizedDescription
  }
}

extension GoogleAuthenticationViewState {
  enum AuthenticationState {
    case signedIn
    case signedOut
  }
}
