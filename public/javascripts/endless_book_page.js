// endless_page.js
var currentPage = 1;
var dontCheckScroll = false;

function checkScroll() {
  if (dontCheckScroll) return;
  
  if (nearBottomOfPage()) {
    currentPage++;
    $.ajax({type: 'GET', url: '/books.js?page=' + currentPage, dataType: 'script'});
  } else {
    setTimeout("checkScroll()", 250);
  }
}

function nearBottomOfPage() {
  return scrollDistanceFromBottom() < 80;
}

function scrollDistanceFromBottom(argument) {
  return pageHeight() - (window.pageYOffset + self.innerHeight);
}

function pageHeight() {
  return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

$(document).ready(function() {
  checkScroll();
});