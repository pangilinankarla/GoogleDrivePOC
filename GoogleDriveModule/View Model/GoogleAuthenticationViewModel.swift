//
//  GoogleAuthenticationViewModel.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 7/18/22.
//

import Combine
import Foundation

final class GoogleAuthenticationViewModel: ObservableObject {
  @Published private(set) var viewState: GoogleAuthenticationViewState = .idle()
  private let googleSignInAuthenticator: SignInAuthenticator
  private let intents: PassthroughSubject<AuthenticationIntent, Never> = .init()
  private var cancellables: Set<AnyCancellable> = .init()

  init(_ googleSignInAuthenticator: SignInAuthenticator) {
    self.googleSignInAuthenticator = googleSignInAuthenticator
    compose()
  }

  deinit {
    cancellables.removeAll()
  }

  func emits(_ intent: AuthenticationIntent) {
    intents.send(intent)
  }

  func handleUrl(_ url: URL) {
    googleSignInAuthenticator.handleUrl(url)
  }
}

extension GoogleAuthenticationViewModel {
  private func compose() {
    intents
      .map { [unowned self] intent in
        self.intentToAction(intent)
      }
      .flatMap { [unowned self] action in
        self.actionToResult(action)
      }
      .scan(GoogleAuthenticationViewState.idle()) { [unowned self] (state, result) in
        self.reduce(result, state)
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
      .removeDuplicates()
      .sink { [unowned self] state in
        self.viewState = state
      }
      .store(in: &cancellables)
  }

  private func intentToAction(_ intent: AuthenticationIntent) -> AuthenticationAction {
    switch intent {
    case .signIn:
      return .signInAction
    case .signOut:
      return .signOutAction
    case .disconnect:
      return .disconnectAction
    case .restorePreviousSignIn:
      return .restorePreviousSignInAction
    }
  }

  private func actionToResult(_ action: AuthenticationAction) -> AnyPublisher<
    AuthenticationResult, Never
  > {
    switch action {
    case .signInAction:
      return googleSignInAuthenticator.signIn()
        .map { user in
          .signInResult(.success(user))
        }
        .prepend(.signInResult(.loading))
        .catch { error in
          Just(AuthenticationResult.signInResult(.error(error)))
        }
        .eraseToAnyPublisher()

    case .signOutAction:
      return googleSignInAuthenticator.signOut()
        .map { .signOutResult }
        .eraseToAnyPublisher()

    // TODO: before push ‼️ DELETE THIS ON MODULE ‼️
    //    case .disconnectAction:
    //      return googleSignInAuthenticator.disconnect()
    //        .replaceError(with: ())
    //        .flatMap { [self] () -> AnyPublisher<Void, AuthenticationError> in
    //          googleSignInAuthenticator.signOut()
    //            .setFailureType(to: AuthenticationError.self)
    //            .eraseToAnyPublisher()
    //        }
    //        .map { .disconnectResult(.success) }
    //        .replaceError(with: .disconnectResult(.success))
    //        .eraseToAnyPublisher()

    case .disconnectAction:
      return googleSignInAuthenticator.disconnect()
        .replaceError(with: ())
        .flatMap { [self] () -> AnyPublisher<Void, Never> in
          googleSignInAuthenticator.signOut()
            .eraseToAnyPublisher()
        }
        .map { .disconnectResult(.success) }
        .eraseToAnyPublisher()

    case .restorePreviousSignInAction:
      return googleSignInAuthenticator.restorePreviousSignIn()
        .map { user in
          .restoreSignInResult(.success(user))
        }
        .prepend(.restoreSignInResult(.loading))
        .catch { error in
          Just(AuthenticationResult.restoreSignInResult(.error(error)))
        }
        .eraseToAnyPublisher()
    }
  }

  private func reduce(
    _ result: AuthenticationResult,
    _ previousState: GoogleAuthenticationViewState
  ) -> GoogleAuthenticationViewState {
    var state = previousState

    switch result {
    case .signInResult(let googleSignInResult):
      switch googleSignInResult {
      case .loading:
        state.error = nil
        break
      case .success(let user):
        state.user = user
        state.authenticationState = .signedIn
        state.error = nil
      case .error(let error):
        state.user = nil
        state.authenticationState = .signedOut
        state.error = error
      }

    case .signOutResult:
      state.user = nil
      state.authenticationState = .signedOut
      state.error = nil

    case .restoreSignInResult(let restoreGoogleSignInResult):
      switch restoreGoogleSignInResult {
      case .loading:
        state.error = nil
        break
      case .success(let user):
        state.user = user
        state.authenticationState = (user != nil) ? .signedIn : .signedOut
        state.error = nil
      case .error(let error):
        state.error = error
      }
    case .disconnectResult(let disconnectResult):
      switch disconnectResult {
      case .success:
        state.user = nil
        state.authenticationState = .signedOut
        state.error = nil
      case .error(let error):
        state.error = error
      }
    }

    return state
  }
}

extension GoogleAuthenticationViewModel {
  enum AuthenticationIntent {
    case signIn
    case signOut
    case disconnect
    case restorePreviousSignIn
  }

  enum AuthenticationAction {
    case signInAction
    case signOutAction
    case disconnectAction
    case restorePreviousSignInAction
  }
}
