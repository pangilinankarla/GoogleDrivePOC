source 'https://github.com/CocoaPods/Specs.git'

iosTarget = '15.0'
platform :ios, iosTarget

target 'GoogleDrivePOC' do
  use_frameworks! # dynamic frameworks

  # Pods for GoogleDrivePOC
  pod 'GoogleSignIn'
  pod 'GoogleAPIClientForREST/Drive'
#  pod 'GoogleSignInSwiftSupport' # SwiftUI support

  script_phase :name => 'Google Sign In URL Scheme', :script => '"$SRCROOT/google-sign-in.sh"'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
