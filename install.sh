#!/bin/sh
target=/usr/local/bin

echo "Installing latest 'mob' release from GitHub"
case "$(uname -s)" in
   Darwin)
      system="darwin"
     ;;
   *)
      system="linux"
     ;;
esac
url=$(curl -s https://api.github.com/repos/remotemobprogramming/mob/releases/latest \
| grep "browser_download_url.*mob_.*${system}_amd64\.tar\.gz" \
| cut -d ":" -f 2,3 \
| tr -d \")
# echo "$url"
tarball="${url##*/}"

curl -sSL $url | tar xz

echo "trying to install mob to $target"
mv mob $target
if [ $? != 0 ]
then
  local_target=$(systemd-path user-binaries)
  echo $local_target
  if [ -d $local_target ]
  then
    echo "you don't have root rights. will install mob to $local_target instead."
    mv mob $local_target
  else 
    echo "failed to install into $target."
  fi
fi

location="$(which mob)"
echo "Mob binary location: $location"

version="$(mob version)"
echo "Mob binary version: $version"