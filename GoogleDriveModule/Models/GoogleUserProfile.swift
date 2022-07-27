//
//  GoogleUserProfile.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 7/27/22.
//

import GoogleSignIn

final class GoogleUserProfile {
  private let profile: GIDProfileData

  init(_ profile: GIDProfileData) {
    self.profile = profile
  }

  var email: String {
    profile.email
  }

  var name: String {
    profile.name
  }

  var givenName: String {
    profile.givenName ?? ""
  }

  var familyName: String {
    profile.familyName ?? ""
  }

  var hasImage: Bool {
    profile.hasImage
  }

  /// Gets the user's profile image URL for the given dimension in pixels for each side of the square.
  ///
  /// - Parameters:
  ///   - dimension: The desired height (and width) of the profile image.
  /// - Returns: An optional URL of the user's profile image.
  func getImageURLWithDimension(_ dimension: UInt) -> URL? {
    profile.imageURL(withDimension: dimension)
  }
}
