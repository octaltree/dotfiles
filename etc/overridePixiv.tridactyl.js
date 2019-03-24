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
pixiv.wait = function(f, callback){
  const rec = () => {
    if( ! f() ) setTimeout(rec, 100);
    else callback();
  };
  rec();
};
pixiv.waitOverrideView = function(){
  const p = pixiv;
  const d = document;
  const w = window;
  const identifier = `override-pixivmanga`;
  if( ! /mode=manga/.test(w.location.href) ) return;
  if( ! d || ! d.body ) return;
  if( p.first(`div.${identifier}`) ) return;
  p.wait(function(){
    const btn = p.first('.toggle-thumbnail');
    if( ! btn ) return false;
    btn.click();
    return p.first('li.thumbnail-item img');
  }, p.overrideView);
};
pixiv.overrideView = function(){
  const p = pixiv;
  const d = document;
  const w = window;
  const identifier = `override-pixivmanga`;
  const thumbs = p.select('li.thumbnail-item img').map(img => img.src);
  const larges = p.select('img.image').map(img => img.dataset.src);
  const breadcrumbs = p.first('ul.breadcrumbs');
  d.body.innerHTML = `
<nav>${breadcrumbs.outerHTML}</nav>
<ul class="thumbnail-items">
  ${thumbs.map((url, idx) => `<li class="thumbnail-item"><a href="#large${idx}"><img src="${url}" /></a></li>`).join('')}
</ul>
${larges.map((url, idx) => `
<div class="large-container" id="large${idx}">
  <a href="${idx == larges.length - 1? '#large0': `#large${idx+1}`}">
    <img src="${url}" />
  </a>
</div>
`).join('\n')}
<div class="${identifier}" />
<style>
.large-container {
  width: 100%;
  height: 100vh;
  text-align: center;
}
.large-container img {
  width: auto;
  height: auto;
  max-width: 95%;
  max-height: 95%;
}
</style>
    `;
};
pixiv.waitOverrideView();
