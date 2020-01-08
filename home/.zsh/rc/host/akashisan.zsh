function haveCmd(){
  type $1 > /dev/null 2>&1
  return $?
}
function proxyCargo(){
  local proxy="$2"
  local on="proxy = \"$proxy\""
  local off="proxy = \"\""
  local q=`[ "$1" = "on" ] && echo "s/$off/$on/g" || echo "s/$on/$off/g"`
  sed $q -i ~/.cargo/config --follow-symlinks
}
function proxySsh(){
  local proxy="$2"
  local file="$HOME/.ssh/config"
  local str="Host *.*\n  ProxyCommand nc -X connect -x $proxy %h %p\n"
  [ "$1" = "on" ] &&\
    echo -n "$str" >> $file &&\
    return;
  python3 -c "s=open('$file', 'r').read();\
    open('$file', 'w').write(s.replace('$str', ''))"
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
  proxySsh on "$proxy"
  echo "proxy=$proxy" >> ~/.curlrc
  # /systemd/system/multi-user.target.wants/docker.service
  # Environment="HTTP_PROXY=http://proxy.uec.ac.jp:8080/,HTTPS_PROXY=http://proxy.uec.ac.jp:8080/"
  proxyCargo on "$proxy"
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
  proxySsh off "$proxy"
  sed '/^proxy=.*$/d' -i ~/.curlrc
  proxyCargo off "$proxy"
}

(){
  if [ -z "$TMUX" ]; then
    if [ `tmux list-sessions| sed '/attached/d'| wc -l` -ne 0 ]; then
      target=`tmux list-sessions| sed '/attached/d'| awk -F: '{print $1}'| head -n 1`
      tmux attach-session -t $target
    else
      tmux
    fi
  fi

  #local proxy="proxy.uec.ac.jp:8080"
  #if [ "\"UECWireless\"" = `iwconfig 2>/dev/null| sed '/ESSID/!d'| awk -F: '{print $2}'` ] ||\
  #  [ "\"106F3F356510\"" = `iwconfig 2>/dev/null| sed '/ESSID/!d'| awk -F: '{print $2}'` ]; then
  #  proxyOn $proxy
  #else
  #  proxyOff $proxy
  #fi
}
