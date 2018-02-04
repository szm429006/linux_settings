'use strict';

hljs.initHighlightingOnLoad();

var scrollView = document.querySelector('.Container .Contents');
var tabs = document.querySelectorAll('.Container .Contents .Content');
var nav = document.querySelectorAll('.Container nav a');
var currentNav = document.querySelector('.Container nav .current');
var currentTab = 0;

currentNav.style.width = nav[currentTab].clientWidth + 'px';
scrollView.style.height = tabs[currentTab].clientHeight + 'px';

nav.forEach(function (link) {
  link.addEventListener('click', function (e) {
    e.preventDefault();
    var index = Array.prototype.indexOf.call(nav, e.target);
    if (currentTab === index) return;
    animateToTab(index);
  });
});

var animateToTab = function animateToTab(index) {
  var el = tabs[index];
  var scrollStart = scrollView.scrollLeft;
  var startHeight = scrollView.clientHeight;
  nav[currentTab].classList.remove('active');
  nav[index].classList.add('active');

  var time = {
    start: performance.now(),
    duration: 700
  };

  var tick = function tick(now) {
    time.elapsed = now - time.start;
    var fadeOut = easeInOutCubic(time.elapsed, 1, -1, time.duration);
    var fadeIn = easeInOutCubic(time.elapsed, 0, 1, time.duration);
    var offset = easeInOutCubic(time.elapsed, scrollStart, el.offsetLeft - scrollStart, time.duration);
    var height = easeInOutCubic(time.elapsed, startHeight, el.clientHeight - startHeight, time.duration);

    var navOffset = easeInOutCubic(time.elapsed, nav[currentTab].offsetLeft, nav[index].offsetLeft - nav[currentTab].offsetLeft, time.duration);

    var indicatorWidth = easeInOutCubic(time.elapsed, nav[currentTab].clientWidth, nav[index].clientWidth - nav[currentTab].clientWidth, time.duration);

    currentNav.style.transform = 'translateX(' + navOffset + 'px)';
    currentNav.style.width = indicatorWidth + 'px';

    tabs[currentTab].style.opacity = fadeOut;
    tabs[index].style.opacity = fadeIn;
    scrollView.scrollLeft = offset;
    scrollView.style.height = height + 'px';

    if (time.elapsed < time.duration) {
      requestAnimationFrame(tick);
    } else {
      currentTab = index;
    }
  };

  requestAnimationFrame(tick);
};

var easeInOutCubic = function easeInOutCubic(t, b, c, d) {
  if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
  return c / 2 * ((t -= 2) * t * t + 2) + b;
};