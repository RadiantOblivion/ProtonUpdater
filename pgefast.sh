#!/usr/bin/env bash
baseuri="https://github.com/GloriousEggroll/proton-ge-custom/releases/download"
latesturi="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"
dstpath="$HOME/.steam/root/compatibilitytools.d"

RestartSteam() {
  if [ "$( pgrep steam )" != "" ]; then
    echo "Restarting Steam"
    pkill -TERM steam #restarting Steam
    sleep 5s
    nohup steam </dev/null &>/dev/null &
  fi
}

  latestversion="$(curl -s $latesturi | grep -E -m1 "tag_name" | cut -d \" -f4)"
  if [[ -d $dstpath/$latestversion ]]
  then
    echo "$latestversion is the latest version and is already installed."
    sleep 1
    echo "Exiting..."
    sleep 1
    exit 0
  else
    echo "$latestversion is the latest version and is not installed yet."
    sleep 3
    echo "Installing the latest version of Proton now!"
    sleep 2
    url=$(curl -s $latesturi | grep -E -m1 "browser_download_url.*.tar.gz" | cut -d \" -f4)
  fi

rsp="$(curl -sI "$url" | head -1)"
echo "$rsp" | grep -q 302 || {
  echo "$rsp"
  exit 1
}

[ -d "$dstpath" ] || {
    mkdir "$dstpath"
    echo [Info] Created "$dstpath"
}

curl -sL "$url" | tar xfzv - -C "$dstpath"

RestartSteam
