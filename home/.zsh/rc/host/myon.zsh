
function haveCmd(){
  type $1 > /dev/null 2>&1
  return $?
}

proxy="proxy.uec.ac.jp:8080"
if [ "\"UECWireless\"" = `iwconfig 2>/dev/null| sed '/ESSID/!d'| awk -F: '{print $2}'` ]; then
  export http_proxy="$proxy"
  export https_proxy="$proxy"
  export HTTP_PROXY="$proxy"
  export HTTPS_PROXY="$proxy"
  if haveCmd "git"; then
    git config --global http.proxy $proxy
    git config --global https.proxy $proxy
  fi
  echo "Host *" >> ~/.ssh/config
  echo "  ProxyCommand nc -X connect -x $proxy %h %p" >> ~/.ssh/config
  echo "proxy=$proxy" >> ~/.curlrc
else
  export http_proxy=""
  export https_proxy=""
  export HTTP_PROXY=""
  export HTTPS_PROXY=""
  if haveCmd "git"; then
    git config --global http.proxy ''
    git config --global https.proxy ''
  fi
  if haveCmd "python3"; then
    python3 -c "fr = open('$HOME/.ssh/config', 'r'); str=fr.read().replace('Host *\n  ProxyCommand nc -X connect -x $proxy %h %p\n', ''); fw = open('$HOME/.ssh/config', 'w'); fw.write(str)"
    python3 -c "fr = open('$HOME/.curlrc', 'r'); str=fr.read().replace('proxy=$proxy\n', ''); fw = open('$HOME/.curlrc', 'w'); fw.write(str)"
  fi
fi
