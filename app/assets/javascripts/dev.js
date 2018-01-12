(function() {

// DEFAULT JS DEV FILE
function show(str){
  return console.log(str);
}

/**
* SCROLL TO ELEMENT WITH DELAY, +- myoffset
* @copyright Oles Bolotniuk
* @since 14:44 - 28.11.2013
**/
function scrollTo(elem, delay, myoffset){
  if(!delay)
    delay = 1000;

  if(!myoffset)
    myoffset = 0;

  $('html, body').animate({
    scrollTop: elem.offset().top+(myoffset)
  }, delay);
}

/**
*   CHECK EMAIL BY REGEXP
**/
function validateEmail(email) { 
  var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
}

// SHOW ERRORS FOR FIELDS
function showError(elem, error, inline, cls) {
  if (inline == true) {
    $(cls + ' #' + elem + '-error').css('display', 'inline-block');
  } else {
    $(cls + ' #' + elem + '-error').show();
  }

  $(cls + ' #' + elem + '-error').html(error);
  $(cls + ' input[name="' + elem + '"]').addClass('error');
}

$(document).ready(function(){
  // Verify CSRF token
  $.ajaxSetup({
    headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  if($('.no_articles').length>0){
    var height = $(window).height()-$('.footer').height()-200;
    $('.no_articles').css('height', height+'.px' );
  }

  // Scolling for search block
  var mainMenu = $('#mainmenu'),
      currentLink = mainMenu.find('a[href="'+location.pathname+location.hash+'"]'),
      goToHash = function(target){
        $('html, body').animate({scrollTop: $(target).offset().top-mainMenu.height()}, 500, function() {
          location.hash = target;
        });
      };

  mainMenu.on('click', 'a', function(e) {
    var self = $(this)[0],
        hash = self.hash,
        pathname = self.pathname;

    if (hash.length > 1 && location.pathname === pathname) {
      e.preventDefault();
      mainMenu.find('a').removeClass('active');
      $(this).addClass('active');
      goToHash(hash);
    }
  });

  setTimeout(function() {
    if (location.hash.length > 1 && currentLink.length > 0) {
      window.scrollTo( 0, 0 );
      mainMenu.find('a').removeClass('active');
      currentLink.addClass('active');
      goToHash(location.hash)
    }
  }, 20);


  /**
  *   HIDE ERRROS IF KEYDOWN OR CONTENT CHANGE
  *   @ signin form inputs
  **/
  $('.login input,.pass-recover input,.new_pass input,.resend input').on('click, focus', function(){
    if($(this).hasClass('error')){
      $(this).removeClass('error');
      $('#'+$(this).attr('id')+'-error').hide();
    }
  })


  //seting screen height to main page sections
  var screenHeight = $(window).height() - $('#search').height();

  if($('.hero.screen').hasClass('long'))
    $(".hero.screen").height(screenHeight);
  else
    $(".hero.screen").height(screenHeight/2.5);

  // setting screen height to about us page
  if ($(window).width() > 1024 ) {
    var screenAboutHeight = $(window).height() - $('.page-head').height() - $('.stripe-dotted').height() - 68;
    var screenAboutScale = screenAboutHeight * 0.13 / 100;

    $(".sewing-block > div").css({
      '-webkit-transform' : 'scale(' + screenAboutScale + ')',
      '-moz-transform'    : 'scale(' + screenAboutScale + ')',
      '-ms-transform'     : 'scale(' + screenAboutScale + ')',
      '-o-transform'      : 'scale(' + screenAboutScale + ')',
      'transform'         : 'scale(' + screenAboutScale + ')'
    });
  }

  $(".sewing-block").height(screenAboutHeight);

  /**
  *   LOGIN POPUP
  **/
  // WTF THIS ????
  $('.login,.pass-recover').on('click', 'a', function(e){
    if(!$(this).attr('href') || ($(this).attr('href') && !$(this).attr('href').length))
      e.preventDefault();
  })

  /**
  *   SIGN IN CLICK
  *   @header
  **/
  $('.signin').on('click', function(e){
    e.preventDefault();
    $('.login').fadeIn();
    $('.pass-recover').fadeOut();
    $('.login').addClass('hover');
  })

  /**
  *   CANCEL BUTTON IN SIGN IN
  **/
  $('.login .cancel').on('click', function(){
    $('.login').fadeOut(function(){
      $('.login .inputs').show();
      $('.login .reset-message').hide();
    });
    $('.login input').val('');
    $('.login input').keydown();
  })

  /**
  *   CANCEL BUTTON IN RECOVER
  **/
  $('.pass-recover .cancel').on('click', function(){
    $('.pass-recover').fadeOut();
  })   

  /**
  *   SHOW SIGN IN 
  *   @ recover
  **/
  $('.pass-recover .showsign').on('click', function(){
    $('.pass-recover').fadeOut();
    $('.login').fadeIn();
  })    

  /**
  *   SHOW RESTORE PASS POPUP
  **/
  $('.login .to_restore').on('click', function(){
    $('.login').fadeOut();
    $('.pass-recover').fadeIn();
  })

  /**
  *   CHECK SIGNIN INPUTS
  **/
  function checkSignin(){
    var error = {};

    // validate email
    if(!validateEmail($('.login #email').val()))
      error.email = 'enter valid email';

    //check pass length
    if($('.login #password').val().length<6 && ( $('.login #fid').val()=='' && $('.login #lid').val()=='' ) )
      error.password = 'at least 6 symbols';

    if(jQuery.isEmptyObject(error)==true){
      return true;
    }else{
      for(var i in error){
        showError(i,error[i],true,'.popup.login');
      }
    }
  }

  /**
  *   SIGN IN BUTTON
  **/
  $('.login .signin').on('click', function(){

    // IF CHECK RETURNS TRUE
    if(checkSignin()){

      var send = $('form#login').serialize();

      // SEND DATA TO SERVER

      $.ajax({
        url: '/ajax/signin', 
        data: send,
        type: "POST",
        xhrFields: { withCredentials: true },
        crossDomain: true,
        success: function(data){
          if (data.results === 'reset_password') {
            $('.login .inputs').fadeOut(function() {
              $('.login .reset-message').fadeIn();
            });
          } else {
            window.location.reload();
          }
        },
        error: function(data) {
          showError('global', data.responseJSON.messages, true, '.login');
        }
      })

    }
  })

  /**
  * CLICK ON FACEBOOK BUTTON
  **/
  $('.signup#fb').on('click', function(e){
    e.preventDefault();

    // GET STATUS
    FB.getLoginStatus(function(response) {

      // IF CONNECTED - FILL INPUTS
      if (response.status === 'connected') {
      
      FB.api('/me', function(response) {
        response.inp = 'fid';
        fill(response);
      });

      } else {

      // LOG IN
         FB.login(function(response) {
         if (response.authResponse) {

        // FILL INPUTS
         FB.api('/me', function(response) {
           response.inp = 'fid';
           fill(response);
         });

         } else {
        
         }
       }, {scope: ['email']} );

      }
     });

  })


  /**
  *   CLICK ON FACEBOOK BUTTON
  **/
  $('.login #fb, #signin_fb').on('click', function(e){
    e.preventDefault();

    // GET STATUS
    FB.getLoginStatus(function(response) {

      // IF CONNECTED - FILL INPUTS
      if (response.status === 'connected') {
      
      FB.api('/me', function(response) {
        response.inp = 'fid';
        login_fill(response);
        $('.login .signin, .form-signin .submit').click();
      });

      } else {

      // LOG IN
         FB.login(function(response) {
         if (response.authResponse) {

        // FILL INPUTS
         FB.api('/me', function(response) {
           response.inp = 'fid';
           login_fill(response);
           $('.login .signin, .form-signin .submit').click();
         });

         } else {
        
         }
       }, {scope: ['email']} );

      }
     });
  })

  /**
  *   CLICK ON LINKEDIN BUTTON
  **/
  $('.login #li').on('click',function(e){
    e.preventDefault();
    IN.UI.Authorize().params({"scope":["r_fullprofile", "r_emailaddress","r_contactinfo"]}).place();
    IN.Event.on(IN, "auth", onLoginLinkedInAuth);
  })

  /**
  *   LINKED IN AUTH CALLBACK
  **/
  function onLoginLinkedInAuth(){
    IN.API.Profile("me").fields([ "id","firstName", "lastName","languages","emailAddress"]).result(getProfile);
  }

  /**
  *   LINKED IN PROFILE
  **/
  function getProfile(profiles) {
    var member = profiles.values[0]; 
    var response = {
      'name':member.lastName+' '+member.firstName,
      'email':member.emailAddress,
      'inp':'lid',
      'id':member.id
    };
    login_fill(response);
    $('.login .signin').click();
  }

  /**
  *   FILL INPUTS BY SOME SOCIALS
  **/
  function login_fill(response){

    // NAME
    $('.login input[name="name"], .form-signin input[name="name"]').val(response.name);
    $('.login input[name="name"], .form-signin input[name="name"]').click();

    // EMAIL
    $('.login input[name="email"], .form-signin input[name="email"]').val(response.email);
    $('.login input[name="email"], .form-signin input[name="email"]').change();

    // FILL HIDDEN SOCIAL FIELD
    $('.login input[name="'+response.inp+'"], .form-signin input[name="'+response.inp+'"]').val(response.id);
  }


  /**
  *   ADD HOVER CLASS
  *   TO POPUPS
  **/
  $('.popup').hover(function(){
    $(this).addClass('hover');
  }, function(){
    $(this).removeClass('hover');
  })

  /**
  *   CLOSE POPUP ON BODY CLICK
  **/
  $('body').on('click', function(){
    if(!$('.popup').hasClass('hover')){
      $('.popup').fadeOut();
    }
  })

  /**
  *   RECOVER BUTTON CLICK
  **/
  $('.recover').on('click', function(){

    if(checkRecover()){

      var email = $('#recover_email').val();
      var send = {
        'email':email,
        'ajax':1
      }

      $.post('/ajax/recover', send, function(data){
        if(data.result=='ok')
          $('.pass-recover .cont').fadeOut(function(){
            $('.pass-recover .recover-success').fadeIn();
          });
        else{
          showError('recover_email',data.message,true,'.pass-recover');
        }
      })
    }

  })

  $('.recover-success .ok').on('click', function(){
    $('.pass-recover').fadeOut(function(){
      $('.pass-recover .cont').show();
      $('.pass-recover .cont input').val('');
      $('.pass-recover .recover-success').hide();
    });
  })

  /**
  *   CHECK RECOVER FORM FIELDS
  **/
  function checkRecover(){
    var error = {};
    var email = $('#recover_email').val();
    if(!validateEmail(email)){
      error.recover_email = 'invalid email'
    }

    if(jQuery.isEmptyObject(error)==true){
      return true;
    }else{
      for(var i in error){
        showError(i,error[i],true,'.pass-recover');
      }
    }
  }

  /**
  *   SAVE NEW PASSWORD
  **/
  $('.save-password').on('click', function(){
    if(checkPass()){
      var token = $('#token').val();
      var pass = $('#password1').val();

      var send = {
        'ajax':1,
        'pass':pass,
        'token':token
      }

      $.post('/ajax/newpass', send, function(dt){
        if(dt=='ok'){
          window.location = '/main/recover_success';
        }else
          window.location.reload();
      })

    }
  })

  /**
  *   CHECK PASSWORD FOR RECOVERY
  **/
  function checkPass(){
    var error = {};
    var pass1 = $('#password1').val();
    var pass2 = $('#password2').val();

    if(pass1.length<6)
      error.password1 = 'at least 6 symbols'

    if(pass2.length<6)
      error.password2 = 'at least 6 symbols'

    if(pass1!=pass2)
      error.password2 = 'passwords are not equal'

    if(jQuery.isEmptyObject(error)==true)
      return true;
    else
      for(var i in error)
        showError(i,error[i],true,'.new_pass');

  }
    
  /**
  *   SAVE NEW PASSWORD
  **/
  $('.resend button').on('click', function(){
    var error = {};
    var email = $('#resend_email').val();
    if(!validateEmail(email)){
      error.resend_email = 'invalid email'
    }

    // SHOW ERROR OR SEND AJAX
    if(jQuery.isEmptyObject(error)==false)
      for(var i in error)
        showError(i,error[i],false,'.resend');
    else{
      var send = {
        'ajax':1,
        'email':email
      }
      $.post('/ajax/resend', send, function(dt){
        var data = JSON.parse(dt);
        if(data.result=='ok'){
          window.location = '/main/resend_success';
        }else{
          showError('resend_email',data.message,false,'.resend');
        }
      })
    }
  })


  /**
  *   SLIDER
  *   NEXT AND PREV BUTTONS
  **/ 

  if ($(".gallery").length > 0){
    var done = true;
    var margin = Math.round(parseFloat($('.overlay').css('margin-left')));
    $('#slide-0').css('margin-left',margin+'.px');
    $('#slide-0').addClass('active');

    var current =  0;
    var curmargin = 0;
    var count = $('.slide').length;
    var left = 0;
    var opacity = 0.2;

    $('.prev').css('opacity',opacity);
    if(current==count-1)
      $('.next').css('opacity',opacity);

    var width = $(".overlay").width();
    $(".slide").width(width);
    $(".slide").each(function(){
      $(this).html("<div class='picholder'>"+$(this).html()+"</div>");
    })
    $(".picholder").width(width);
    $(".slide .pic").css("width", width);
    if ($(".overlay").width() <=  1000) {
      $(".slide img").css("maxWidth", width);
    }

    $('.overlay')
    .on('swipeleft', function(e) {
      $(".next").click();
    })
    .on('swiperight', function(e) {
      $(".prev").click();
    })
    $('.overlay')
    .on('movestart', function(e) {
      if ((e.distX > e.distY && e.distX < -e.distY) || (e.distX < e.distY && e.distX > -e.distY)) {
        e.preventDefault();
      }
    })
  }


  /**
  *   NEXT BUTTON
  **/
  $('.next').on('click', function(){
    if(done){

      if(current<count-1){
        
        // MAKE VISIBLA PREV
        $('.prev').css('opacity',1);
        
        // NOT COMPLETE
        done = false;

        // ANIMATE
        slideTo(++current);

        // CHANGE ACTIVE SLIDES
        $('.slide').removeClass('active');
        $('#slide-'+current).addClass('active');
        
        // IF LAST - MAKE OPACITY LOWER
        if(current==count-1)
          $('.next').css('opacity',opacity);

      }
    }
  })

  /**
  *   PREV BUTTON
  **/
  $('.prev').on('click', function(){
    if(done){

      // IF FIRST - LOW OPACITY
      if(current==0)
          $('.prev').css('opacity',opacity);

      // IF CURRENT IS NOT FIRST
      if(current>0){

        // MAKE NEXT VISIBLE
        $('.next').css('opacity',1);

        // NOT COMPLETE
        done = false;

        // ANIMATE
        slideTo(--current);

        // CHANGE ACTIVE SLIDES
        $('.slide').removeClass('active');
        $('#slide-'+current).addClass('active');

        // IF FIRST - MAKE OPACITY LOWER
        if(current==0)
          $('.prev').css('opacity',opacity);
      }
    }
  })

  function slideTo (pos) {
    if(pos>=0)
      var left = pos * width;

    current = pos;
    $('.holder').animate({'margin-left':-left+'px'},500, function(){
      done = true;
    });  

    $('.athumbs').removeClass('active');

    $('.athumbs').each(function(){
      if( $(this).data('id')==current )
        $(this).addClass('active');
    })
  }

  $('.athumbs').on('click', function(e){
    e.preventDefault();
    var id = $(this).data('id');
    slideTo(id);
  })

  /**
  *   LOAD MORE ARTICLES
  **/
  $('.load_more#articles').on('click', function(e){
    e.preventDefault();

    var link = $(this).data('link');
    var button = $(this);

    $('.load_more .content').hide();
    $('.load_more .loader').show();
    
    var shown = [];
    $('article.shown').each(function(){
      shown.push($(this).data('id'))
    })

    var send = {
      'ajax':1,
      'anchor':anchor,
      'limit':$(this).data('limit'),
      'order':$('.sort_by a.active').data('order'),
      'shown':shown
    }

    $.post('/ajax/'+link, send, function(dt){
      data = JSON.parse(dt);
      $('.news-cont').append(data.html);
      articles_shown += data.count;
      if(articles_shown==articles_count){
        button.fadeOut();
      }
    }).done(function(){
      $('.load_more .loader').hide();
      $('.load_more .content').show();
    })
  })

  /**
  *   SORT BY BUTTON
  **/
  $('a.sort').on('click', function(e){
    e.preventDefault();

    if($(this).hasClass('active'))
      return;

    $('a.sort').removeClass('active');
    $(this).addClass('active');

    $('.bigloader').show();
    $('.news-cont').hide();

    var shown = [];
    $('article.shown.leader').each(function(){
      shown.push($(this).data('id'))
    })

    var order = $(this).data('order');
    var send = {
      'ajax':1,
      'anchor':anchor,
      'order':order,
      'limit':articles_shown,
      'shown':shown
    }

    $.post('/ajax/sortArticles', send, function(dt){
      data = JSON.parse(dt);
      $('.news-cont').html(data.html);
      $('.bigloader').fadeOut(function(){
        $('.news-cont').fadeIn();
      });
    })
  })

  // ON PHONE CLICK @ CONTACTS
  $('.contacts .ph').on('click', function(e){
    e.preventDefault();
    $('.details .val').html($(this).data('val'));
    $('.details').fadeToggle();
  })

  $('.contacts .sendhello').on('click', function(e){
    e.preventDefault();

    if(checkContactsForm()){

      var send = $('.contacts form').serialize();
      send+='&ajax=1';

      $.post('/ajax/feedBack', send, function(data){
        data = JSON.parse(data);
        if(data.result=='ok'){
          $('.contacts .inputs').fadeOut(function(){
            $('.contacts .success').html(data.msg).fadeIn();
          })
        }else{
          alert(data.msg);
        }
      })
    }
  })

    /**
  *   CHECK ALL FIELDS 
  *   AND SHOW ERRORS
  **/
  function checkContactsForm(){

    var error = { };
    $('.contacts div.error').hide();

    // EMAIL
    if($('.contacts input[name="cemail"]').val().length<2)
      error.cemail = 'enter your email'
    
    if(!validateEmail($('.contacts input[name="cemail"]').val()))
      error.cemail = 'invalid email'

    // MESSAGE
    if($('.contacts #cmessage').val().length<2)
      error.cmessage = 'enter message, please'

    /**
    *   RETURN IF ALL IS OK
    *   SHOW ERROR IF NOT
    **/
    if(jQuery.isEmptyObject(error)==true){
      return true;
    }else{
      for(var i in error){
        showError(i,error[i],false,'.contacts');
      }
    }

  }

  // Close alerts
  var $alert = $('.alert'),
      ALERT_TIME = 10000;

  function closeAlerts () {
    $alert.addClass('hide-alert');
  }

  setTimeout(closeAlerts, ALERT_TIME);

  $alert.find('.times').on('click', closeAlerts);

  // About page
  var $sewingBlock = $('.sewing-block');

  $('.overlay section').hover(
    function () {
      $sewingBlock.addClass('hover');
    },
    function () {
      $sewingBlock.removeClass('hover');
    }
  )
});

})();
