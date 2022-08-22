#!/bin/sh

# Constants
REVERSE_GOOGLE_CLIENT_ID="com.googleusercontent.apps.68133388709-7usqlsr4638s5qlu72irfo2i1oti81pj"
INFO_PLIST="GoogleDrivePOC-Info.plist"
KEY_URL_TYPE="CFBundleURLTypes"
KEY_URL_SCHEME="CFBundleURLSchemes"

i=0
j=0
clientIdFound=false

function check_url_type_length {
  checking=true
  while [[ $checking == true ]] ; do
    /usr/libexec/PlistBuddy -c "print :$KEY_URL_TYPE:$i" $INFO_PLIST 2>/dev/null
    if [ $? -ne 0 ]; then
      checking=false
      break
    fi
    i=$(($i + 1))
  done  
}

function check_client_id {
  checking=true
  j=$(($i - 1))
  while [[ $j -gt -1 && $checking == true ]] ; do
    clientId=$(/usr/libexec/PlistBuddy -c "print :$KEY_URL_TYPE:$j:$KEY_URL_SCHEME:0" $INFO_PLIST 2>/dev/null)
    if [[ $REVERSE_GOOGLE_CLIENT_ID == $clientId ]]; then
      checking=false
      clientIdFound=true
      break
    fi
    j=$(($j - 1))
  done
}

function add_client_id_if_needed {
  if [[ $1 == true ]]; then
    echo "Google client ID already exists."
  else
    /usr/libexec/PlistBuddy -c "add :$KEY_URL_TYPE array" $INFO_PLIST;
    /usr/libexec/PlistBuddy -c "add :$KEY_URL_TYPE:$i:$KEY_URL_SCHEME array" $INFO_PLIST;
    /usr/libexec/PlistBuddy -c "add :$KEY_URL_TYPE:$i:$KEY_URL_SCHEME:0 string $REVERSE_GOOGLE_CLIENT_ID" $INFO_PLIST;
    echo "Google client ID added."
    echo "warning: Project's $INFO_PLIST was updated."
  fi
}

echo "Setting URL Scheme for Google Sign In..."
check_url_type_length
check_client_id
add_client_id_if_needed $clientIdFound
