#!/bin/sh

# Constants
REVERSE_GOOGLE_CLIENT_ID="com.googleusercontent.apps.1033453333453-ssjdi116776oaj7mtu0dqi9jbpnt7m9l"
INFO_PLIST="GoogleDrivePOC-Info.plist"
KEY_URL_TYPE="CFBundleURLTypes"
KEY_URL_SCHEME="CFBundleURLSchemes"

echo "Setting URL Scheme for Google Sign In..."

CLIENT_ID=$(/usr/libexec/PlistBuddy -c "print :$KEY_URL_TYPE:0:$KEY_URL_SCHEME:0" "${INFO_PLIST}" 2>/dev/null)

if [[ $? -eq 0 ]]; then
  if [[ "$REVERSE_GOOGLE_CLIENT_ID" == "$CLIENT_ID" ]]; then
    echo "warning: Google Client ID already exists"
  else
    echo "warning: URL types and schemes keys already exist"
    /usr/libexec/PlistBuddy -c "add :CFBundleURLTypes:0 dict" "${INFO_PLIST}";
    echo "Adding $KEY_URL_SCHEME..."
    /usr/libexec/PlistBuddy -c "add :CFBundleURLTypes:0:CFBundleURLSchemes array" "${INFO_PLIST}";
    echo "Adding Google Client ID..."
    /usr/libexec/PlistBuddy -c "add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string ${REVERSE_GOOGLE_CLIENT_ID}" "${INFO_PLIST}";
    echo "Google Client ID added."
  fi
else
  echo "Adding Google Client ID..."
  /usr/libexec/PlistBuddy -c "add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string ${REVERSE_GOOGLE_CLIENT_ID}" "${INFO_PLIST}";
  echo "Google Client ID added."
fi