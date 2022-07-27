//
//  GoogleUser.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 7/27/22.
//

import GoogleSignIn

final class GoogleUser {
  private let user: GIDGoogleUser

  init(_ user: GIDGoogleUser) {
    self.user = user
  }
  var id: String {
    user.userID ?? ""
  }

  var profile: GoogleUserProfile? {
    guard let profile = user.profile else { return nil }

    return GoogleUserProfile(profile)
  }

  var grantedScopes: [String] {
    user.grantedScopes ?? []
  }
}

extension GoogleUser: Equatable {
  static func == (lhs: GoogleUser, rhs: GoogleUser) -> Bool {
    return lhs.user == rhs.user
  }
}
