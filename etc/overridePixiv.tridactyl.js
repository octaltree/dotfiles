(function(){
  function e(elm){
    if( ! elm ) elm = document;
    elm.first = q => e(elm.querySelector(q));
    elm.select = q => Array.from(elm.querySelectorAll(q)).map(x => e(x));
    return elm;
  }
  function wait(f, callback){
    const rec = () => {
      const y = f();
      if( ! y ) setTimeout(rec, 100);
      else callback(y);
    };
    rec();
  }
  function main(shower){
    const btn = shower.parentNode;
    console.log(btn);
    const orig = e().select('a')
      .map(x => x.href)
      .filter(x => RegExp('^https://i.pximg.net/img-original').test(x))[0];
    const master = e().select('img')
      .map(x => x.src)
      .filter(x => RegExp('^https://i.pximg.net/img-master').test(x))[0];
    const urls = [...Array(200).keys()]
      .map(x => master.replace('p0_', `p${x}_`));
    const tags = urls
      .map(u => `<img src="${u}" style="display: none;"/>`)
      .join('');
    console.log(tags);
    document.body.insertAdjacentHTML('afterbegin', tags);
    btn.click();
    //console.log(e().select('a').map(x => x.href));
  }
  wait(function(){
    const tmp = e().select('div')
      .filter(x => RegExp('すべて見る').test(x.textContent));
    if( tmp.length ) return tmp.slice(-1)[0];
  }, main);
})();
