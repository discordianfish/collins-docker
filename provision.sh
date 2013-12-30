#!/bin/sh
TAG=$1
PROFILE=$2
NOTIFY=$3
SUFFIX=$4
LOGFILE=$5

collins_user=blake
collins_password=admin:first

# FIXME: avoid duplicating this from register initrd
call() {
  status=
  data_message=

  TMP=`mktemp`
  if ! curl -s -o "$TMP" --basic -u "$collins_user:$collins_password" -H \
    'Accept: text/x-shellscript' "$@"
  then
    echo "FATAL ERROR: Couldn't connect to collins"
    exit 1
  fi
  . "$TMP"
  rm "$TMP"
}

log() {
  message=$1
  severity=$2
  echo "$severity: $message"
  call -X PUT -d "message=$message" -d type="$severity" \
      "$asset_url/log"
}

collins() {
  reason=$1
  shift
  call "$@"
  if [ "$SUCCESS" != "true" ]
  then
    log "$reason: $data_message" "CRITICAL"

    return 1
  fi
}

asset_url="http://localhost:9000/api/asset/$TAG"
collins "Set to provisioning" -d status=Provisioning -d state=Starting -d reason="Provisioner started" "$asset_url"

# Set systems to install
# Power cycle
# (Optional) Wait for installation to finish
