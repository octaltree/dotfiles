var pixiv = {};
pixiv.list = iter => {
  iter.map = f => Array.prototype.map.call(iter, f);
  iter.forEach = f => Array.prototype.forEach.call(iter, f);
  iter.reduce = (f, zero) => Array.prototype.reduce.call(f, zero);
  iter.filter = f => Array.prototype.filter.call(f);
  iter.toArray = () => iter.map(x => x);
  return iter;
};
pixiv.selector = elm => {
  elm.first = q => elm.querySelector(q);
  elm.select = q => pixiv.list(elm.querySelectorAll(q));
  return elm;
};
pixiv.first = q => pixiv.selector(document).first(q);
pixiv.select = q => pixiv.selector(document).select(q);
pixiv.openLinks = function(){
  const p = pixiv;
  const w = window;
  const uniq = xs => Array.from(new Set(xs));
  uniq(p.select('a').map(a => {
    w.console.log(a);
    const url = a.href;
    if( ! url.match(/member_illust.*illust_id/) ) return;
    if( ! a.querySelector('div') ) return;
    return url;
  })).forEach(url => window.open(url, '_blank'));
};
pixiv.openLinks();
