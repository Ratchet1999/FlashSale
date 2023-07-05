document.addEventListener('click', function(e) {
  var dropdownToggles = document.querySelectorAll('.dropdown-toggle');
  var dropdownMenu = document.querySelector('.dropdown-menu');
  var dropdownToggle = e.target.closest('.dropdown-toggle');
  if (!dropdownToggle) {
    dropdownMenu.classList.remove('show');
    return;
  }
  for (var i = 0; i < dropdownToggles.length; i++) {
      dropdownMenu.classList.toggle('show');
  }
});
