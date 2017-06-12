function haveCmd(){
  type $1 > /dev/null 2>&1
  return $?
}
function proxyFirefox(){
  local proxy="$2"
  local prefs=`find ~/.mozilla/firefox -maxdepth 2 -name "prefs.js"`
  local on='"network.proxy.type", 1'
  local off='"network.proxy.type", 4'
  local q=`[ "$1" = "on" ] && echo "s/$off/$on/" || echo "s/$on/$off/"`
  echo "$prefs"| xargs -L1 sed $q -i
}
function proxyCargo(){
  local proxy="$2"
  local on="proxy = \"$proxy\""
  local off="proxy = \"\""
  local q=`[ "$1" = "on" ] && echo "s/$off/$on/g" || echo "s/$on/$off/g"`
  sed $q -i ~/.cargo/config --follow-symlinks
}
function proxyOn(){
  local proxy="$1"
  export http_proxy="$proxy"
  export https_proxy="$proxy"
  export HTTP_PROXY="$proxy"
  export HTTPS_PROXY="$proxy"
  if haveCmd "git"; then
    git config --global http.proxy $proxy
    git config --global https.proxy $proxy
  fi
  echo "Host *.*\n  ProxyCommand nc -X connect -x $proxy %h %p" >> ~/.ssh/config
  echo "proxy=$proxy" >> ~/.curlrc
  # /systemd/system/multi-user.target.wants/docker.service
  # Environment="HTTP_PROXY=http://proxy.uec.ac.jp:8080/,HTTPS_PROXY=http://proxy.uec.ac.jp:8080/"
  proxyFirefox on $proxy
  proxyCargo on $proxy
}
function proxyOff(){
  local proxy="$1"
  export http_proxy=""
  export https_proxy=""
  export HTTP_PROXY=""
  export HTTPS_PROXY=""
  if haveCmd "git"; then
    git config --global http.proxy ''
    git config --global https.proxy ''
  fi
  # TODO
  #if haveCmd "python3"; then
  #  python3 -c "fr = open('$HOME/.ssh/config', 'r'); print(fr.read()); str=fr.read().replace('Host *.*\n  ProxyCommand nc -X connect -x $proxy %h %p\n', ''); print(str); fw = open('$HOME/.ssh/config', 'w'); fw.write(str)"
  #fi
  sed '/^proxy=.*$/d' -i ~/.curlrc
  proxyFirefox off $proxy
  proxyCargo off $proxy
}

(){
  if [ -z "$TMUX" ]; then
    if [ `tmux list-sessions| sed '/attached/d'| wc -l` -ne 0 ]; then
      target=`tmux list-sessions| sed '/attached/d'| awk -F: '{print $1}'| head -n 1`
      tmux -2 attach-session -t $target
    else
      tmux -2
    fi
  fi

  local proxy="proxy.uec.ac.jp:8080"
  if [ "\"UECWireless\"" = `iwconfig 2>/dev/null| sed '/ESSID/!d'| awk -F: '{print $2}'` ] ||\
    [ "\"106F3F356510\"" = `iwconfig 2>/dev/null| sed '/ESSID/!d'| awk -F: '{print $2}'` ]; then
    proxyOn $proxy
  else
    proxyOff $proxy
  fi
}
