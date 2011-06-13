$(document).ready(function() {
  function resizeCaseStudy() {
    $('.case-study').css({width: $(window).width() - $('.case-study').offset().left})
  }
  if ($('.case-study').length > 0) {
    $(window).resize(resizeCaseStudy);resizeCaseStudy();
  }
  
  // Fix external links
  $("a[href*='http']").not("[href*='" + window.location.host + "'], [rel='external']").each(function() {
    $(this).attr('rel', 'external');
  })
  
  // Record click-throughs to external sites
  $("a[rel=external]").not('.popup').click(function(e) {
    e.preventDefault();
    window.open($(this).attr('href'), '_blank');
  });
  
  $('a.popup').live('click', function(e) {
    e.preventDefault();
    var href = $(this).attr('href');
    var maxWidth = $(window).width() - 200;
    var maxHeight = $(window).height() - 200;
    var height = parseInt($(this).attr('data-height'));
    var width = parseInt($(this).attr('data-width'));
    if (href.indexOf('mp4') > -1) { // Is it a video?
      $('#popup').html('<video width="100%" height="100%" src="' + href + '" poster="' + href.replace('mp4', 'jpg') + '" controls autoplay></video>');
      html5media();
    } else { // No? Assume it's an image
      $('#popup').html('<img width="100%" height="100%" src="' + href + '" alt="' + $(this).attr('title') + '">');
    }
    $('#popup-close').css({top:-40});
    $('#popup-wrapper').css({display:'block', width:1, height: 1, left: $(this).offset().left - $(window).scrollLeft() + ($(this).width() / 2), top: $(this).offset().top - $(window).scrollTop() + ($(this).height() / 2), opacity: 0}).animate({
        width: Math.min(width, maxWidth),
        height: Math.min(height, maxHeight),
        top: ($(window).height() / 2) - (Math.min(height, maxHeight) / 2),
        left: ($(window).width() / 2) - (Math.min(width, maxWidth) / 2),
        opacity:1 },
      { duration: 250,
        easing: 'easeOutQuad',
        complete: function() {
          $('#popup-close').animate({top:0}, {duration:200, easing:'easeOutQuad'});
        } });
  });
  
  var quotePos = 0;
  function scrollQuotes() {
    quotePos -= 280;
    if (Math.abs(quotePos) > $('#quote-list').width() - $('#quote-mask').width()) {
      quotePos = 0;
    }
    $('#quote-list li').eq(quotePos == 0 ? 0 : ((Math.abs(quotePos) + 280) / 280)).css({opacity:0}).animate({opacity:1}, 1000);
    $('#quote-list').animate({left: quotePos}, {duration: 500, easing: 'swing'});
  }
  var quoteInterval = setInterval(scrollQuotes, 7500);
  $('#quotes').hover(function() {
    clearInterval(quoteInterval);
  }, function() {
    quoteInterval = setInterval(scrollQuotes, 7500);
  })
  
  $('#popup-close').live('click', function(e) {
    e.preventDefault();
    $('#popup-wrapper').animate({top:'-=250',opacity:0}, {duration:200, easing: 'easeInQuad', complete: function() { $(this).css({display:'none'}).find('#popup').html('')}})
  });
  
  $("a[href='#getintouch']").click(function(e) {
    e.preventDefault();
    $('body, html').animate({scrollTop: $("a[name='getintouch']").offset().top}, {duration: 300, easing: 'swing', complete: function() {
      $('#contact').animate({backgroundColor: '#444444'}, {duration: 200, complete: function() {
        $('#contact').animate({backgroundColor: '#2e2e2e'}, {duration: 200});
      }});
    }});
  });
  
  var portfolioContainer = $('#portfolio').parents('.container');
  $('#portfolio').css({height: portfolioContainer.height() - 90});
  
  $('#footer .aerospace').hover(function() {
    $('#footer img.aerospace').stop(true).fadeTo('normal', 1);
  }, function() {
    $('#footer img.aerospace').stop(true).fadeTo('fast', 0);
  });
  
  $('#portfolio').find('.paginator a').click(function(e) {
    e.preventDefault();
    $('#portfolio-mask .projects').animate({left: -((parseInt($(this).html()) - 1) * 320)}, 250);
    $('#portfolio .paginator li.active').removeClass('active');
    $(this).parents('li').addClass('active');
  });
  
  $('#people li').hover(function() {
    if (!$(this).hasClass('active'))
      $(this).find('img.color').fadeIn('fast');
  }, function() {
    if (!$(this).hasClass('active'))
      $(this).find('img.color').fadeOut('fast');
  });
  
  $('#people li .avatar').click(function() {
    if ($(this).parents('li').hasClass('active')) {
      if ($(this).parents('li').hasClass('even')) {
        $(this).parents('li').find('dl').animate({opacity:0, right: -195}, 350);
      } else {
        $(this).parents('li').find('dl').animate({opacity:0, left: -195}, 350);
      }
      $(this).parents('li').removeClass('active');
    } else {
      var address = $(this).parents('li').find('h4').html().split(' ')[0].toLowerCase() + '@' + 'makalumedia' + '.com';
      address = address.replace('stefan', 'seiz');
      $(this).parents('li').find('dd.email').html('<a href="mail' + 'to:' + address + '">' + address + '</a>');
      $.each($('#people li').not($(this).parents('li')).removeClass('active'), function(i, item) {
        $(item).find('img.color').fadeOut('fast');
        if ($(item).hasClass('even')) {
          $(item).find('dl').animate({opacity:0, right: -195}, 350);
        } else {
          $(item).find('dl').animate({opacity:0, left: -195}, 350);
        }
      });
      var options = {};
      if ($(this).parents('li').hasClass('even')) {
        options = {opacity:1, right: 75};
      } else {
        options = {opacity:1, left: 75};
      }
      $(this).parents('li').addClass('active').find('dl').animate(options, {duration: 350, easing: 'swing'});
    }
  });
  
  $('#contact-container').css({height:$('#contact').height()});
  $('#contact-container .back').live('click', function(e) {
    e.preventDefault();
    swapContactForm();
  });
  $('a.working-together').click(function(e) {
    e.preventDefault();
    swapContactForm();
  });
  
  $('#contact form').ajaxForm({
    success: function() {
      if ($('#people').length > 0) {
        $('body, html').animate({scrollTop: $('#people').offset().top}, {duration: 300, easing: 'swing'});
        $('#speechbubble').css({display: 'block'}).animate({left: 80, opacity: 1}, {duration: 500, easing: 'easeInOutQuad'}).click(function(e) {
          $('#speechbubble').fadeOut();
        }).find('.name').html($('#name').val().split(' ')[0]);
        setTimeout(function() {
          $('#speechbubble').fadeOut();
        }, 5000);
      } else {
        $('#contact .form').hide();
        $('#contact .success').show();
      }
      $('form .textfield input, form textarea').val('').change();
    }
  });
  
  $('a.submit').click(function(e) {
    e.preventDefault();
    if ($(this).hasClass('active')) {
      $(this).parents('form').submit();
    }
  });
  
  //var hasMoved = false;
  //$('.case-study').mousemove(function(e) {
  //  if (e.pageX > ($(window).width() - 70) && 
  //      !(e.pageY <= ($(this).offset().top + 5) ||
  //        e.pageY >= ($(this).offset().top + $(this).innerHeight() - 5))) {
  //    $('a.arrow.next').stop(true).css({top: e.pageY - $(this).offset().top}, 250);
  //    hasMoved = true;
  //  } else if (hasMoved) {
  //    $('a.arrow.next').animate({top: $(this).height() / 2}, 250);
  //    hasMoved = false;
  //  }
  //});
  
  var currentPosition = 0;
  var offset = 220;
  $('a.arrow.next').click(function(e) {
    e.preventDefault();
    currentPosition -= 320;   
    updateCaseStudyElements();
    $('.case-study .content').animate({left: currentPosition + 240}, {duration: 300, easing: 'easeOutQuad'});
  });
  
  $('a.arrow.prev').click(function(e) {
    e.preventDefault();
    currentPosition += 320;
    $('.arrow.next').show();
    updateCaseStudyElements();
    $('.case-study .content').animate({left: currentPosition + 240}, {duration: 300, easing: 'easeOutQuad'});
  });
  
  var toc = {};
  $.each($('.toc a'), function(i, link) {
    var position = parseInt($(this).attr('href').substr(1));
    toc[position] = $(link);
    $(link).click(function(e) {
      e.preventDefault();
      currentPosition = -position;
      updateCaseStudyElements();
      $('.case-study .content').animate({left: currentPosition + 240}, {duration: 300, easing: 'easeOutQuad'});
    })
  });
  
  $('#quotes a').click(function(e) {
    e.preventDefault();
    var link = $('#portfolio .paginator a#portfolio-' + $(this).attr('href').substr(1));
    if (link.parents('li').hasClass('active')) {
      $('#portfolio').animate({backgroundColor: '#444444'}, {duration: 250, complete: function() {
        $('#portfolio').animate({backgroundColor: '#2e2e2e'}, {duration: 250});
      }});
    } else {
      link.click();
    }
  });
  
  function updateCaseStudyElements() {
    if (currentPosition >= 0) {
      $('.content-shade.left').hide();
      $('a.arrow.prev').hide();
    }
    if (currentPosition < 0) {
      $('.content-shade.left').show();
      $('a.arrow.prev').show();
    }
    if (currentPosition == -1920) {
      $('.arrow.next').hide();
      $('.the-end').fadeIn(1000);
    } else {
      $('.arrow.next').show();
    }
    var currentSection;
    if (currentSection = toc[Math.abs(currentPosition)]) {
      $('.toc a').removeClass('active');
      currentSection.addClass('active');
    }
  }
  
  var filledIn = false;
  $('#contact input, #contact textarea').keyup(function() {
    if ($('#contact #name').val() != "" && $('#contact #email').val() != "" && $('#contact #message').val() != "") {
      if (!$('#contact .submit').hasClass('active')) {
        $('#contact .submit').addClass('active');
      }
    } else {
      $('#contact .submit').removeClass('active');
    }
  });
  $('#contact input, #contact textarea').change(function() {
    if ($('#contact #name').val() != "" && $('#contact #email').val() != "" && $('#contact #message').val() != "") {
      if (!$('#contact .submit').hasClass('active')) {
        $('#contact .submit').addClass('active');
      }
    } else {
      $('#contact .submit').removeClass('active');
    }
  });
  
  initAutoclearFields();
  
  $('a.arrow.next').animate({right: 10}, 500);
});

function initAutoclearFields() {
  $.each($('p.autoclear'), function() {
    var p = $(this);
    var label = p.find('label.autoclear');
    var field = p.find('input, textarea');

    // Sometimes browsers leave values in the field on refresh
    if (field.val() != '') {
      label.hide();
    }
    
    label.click(function() {
      field.focus();
    });
    field.focus(function() {
      label.addClass('dimmed');
      // In case of auto-complete
      if (field.val() != '') {
        label.hide();
      }
    })
    field.blur(function() {
      label.removeClass('dimmed');
      if (field.val() == '') {
        label.show();
      }
    })
    field.keydown(function(e) {
      // Ignore modifier keys
      if ($.inArray(e.keyCode, [9, 27, 16, 17, 18, 20, 144, 224, 91, 92, 93]) == -1) {
        label.fadeOut(200);
      }
    })
    field.change(function() {
      if (field.val() == '') {
        label.show();
      }
    })
  });
}

var contactFormVisible = true
var origTitle;
function swapContactForm() {
  if (contactFormVisible) {
    if (!origTitle) {
      origTitle = $('#contact-container > h2').html();
    }
    $('#contact-container').animate({height:$('#workingtogether').height()});
    $('#contact').animate({left:-940});
    $('#workingtogether').animate({left:0});
    $('#contact-container > h2').html($('#workingtogether h2').html())
      .animate({left:(940 / 2) - ($('#contact-container > h2').outerWidth() / 2) - 10});
    $('body, html').animate({scrollTop: $("a[name='getintouch']").offset().top});
  } else {
    $('#contact-container').animate({height:$('#contact').height()});
    $('#workingtogether').animate({left:940});
    $('#contact').animate({left:0}, {complete: function() {$('#contact').find('#name').focus()}});
    $('#contact-container > h2').html(origTitle)
      .animate({left:20});
  }
  contactFormVisible = !contactFormVisible;
}
