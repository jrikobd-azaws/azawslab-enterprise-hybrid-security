(function () {
  function normaliseText(value) {
    return (value || '').replace(/\s+/g, ' ').trim();
  }

  function applyNavSectionColours() {
    document.querySelectorAll('.md-nav__link').forEach(function (link) {
      var label = normaliseText(link.textContent);

      if (label === 'R1 Workplace') {
        link.classList.add('az-nav-section-label');
        link.classList.add('az-nav-r1-workplace');

        var item = link.closest('.md-nav__item');
        if (item) {
          item.classList.add('az-nav-r1-workplace-item');
        }
      }
    });
  }

  if (window.document$ && typeof window.document$.subscribe === 'function') {
    window.document$.subscribe(function () {
      applyNavSectionColours();
    });
  } else if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', applyNavSectionColours);
  } else {
    applyNavSectionColours();
  }
})();