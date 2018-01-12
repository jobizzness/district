$(document).ready(function(){

  var saving = false;
  var page = '.settings ';
  var error = null;
  var fileloading = false;
  var zoomtimeout = null;

  // Verify CSRF token
  $.ajaxSetup({
    headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  // DISABLE ALL HREFS THAT HAS NO ANCHOR
  $(page+'a').on('click', function(e){
    var href = $(this).attr('href');
    if(!href || href=="#")
      e.preventDefault();
  })

  // CLICK ON "SHOW MAP" - SHOWS POPUP
  $(page+'.on_map').on('click', function(){
    var div = $('div.map-pop');

    if(div.is(':visible')){
      div.fadeOut();
    }else{
      div.fadeIn();
      initMap();
    }
  })

  // ON POPUP "CLOSE" CLICK
  $('div.map-pop .act').on('click', function(){
    $('div.map-pop').fadeOut();
  })

  // TOOGLE TO COMPANY SETTINGS
  $(page+'#company').on('click', function(){
    $('.pads').removeClass('active');
    $(this).addClass('active');
    $(page+'#company_settings').show();
    $(page+'#profile_settings').hide();
    $(page+'#payment_settings').hide();
    error = null;
  })

  // TOGGLE TO PROFILE SETTINGS
  $(page+'#profile').on('click', function(){
    $('.pads').removeClass('active');
    $(this).addClass('active');
    $(page+'#company_settings').hide();
    $(page+'#profile_settings').show();
    $(page+'#payment_settings').hide();
    error = null;
  })

  // TOGGLE TO PAYMENT SETTINGS
  $(page+'#payment').on('click', function(){
    $('.pads').removeClass('active');
    $(this).addClass('active');
    $(page+'#company_settings').hide();
    $(page+'#profile_settings').hide();
    $(page+'#payment_settings').show();
    error = null;
  });

  if($(window).width() <= 1024) {
    $(page+'input,'+page+'textarea').on("focus", function(){
      $(".page-head").css({position:'absolute'})
    })
    $(page+'input,'+page+'textarea').on("blur", function(){
      $(".page-head").css({position:'fixed'})
    })  
  }  

  // SAVE PROFILE BUTTON
  $(page+'.save_profile').on('click', function(e){
    e.preventDefault();

    $(page+'input').removeClass('error');
    $(page+'input').css('border','2px solid #b0b0b0');
    $(page+'div.error').hide();

    if(saving || !checkInputsProfile())
      return;
  
    var btn = $(this);
    var ex = btn.html();
    saving = true;
    btn.html('checking');

    var send = $('form.profile').serialize();

    $.post('/ajax/saveProfile', send)
    .done(function(data) {
      btn.css('background-color', '#37d5b9');
      btn.html('saved');
      $('.passwords').val('');

      setTimeout(function(){
        btn.css('background-color', '#000');
        btn.html(ex);
        saving = false;
      }, 1000);
    })
    .fail(function(data) {
      saving = false;
      console.log(data.responseJSON)
      $.each(data.responseJSON.errors, function(k, v) {
        putError(v.elem, v.message);
      });
    });
  });

  /**
  *   CHECK EMAIL BY REGEXP
  **/
  function validateEmail(email) { 
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  /**
  * CHECK INPUTS IN PROFILE SETTINGS 
  * @copyright Oles Bolotniuk
  * @since 14:44 - 26.11.2013
  **/
  function checkInputsProfile(){
    error = null;
    tab = '#profile_settings';

    // NAME CHECK
    if($(tab + ' #name').val().length<2)
      putError('name','at least 2 symbols')

    // EMAIL CHECK
    if(!validateEmail($(tab + ' #email').val()))
      putError('email','incorrect email')

    // PASSWORDS
    if($(tab + ' #password').val().length>0 && $(tab + ' #password').val().length<6)
      putError('password','at least 6 symbols')

    if($(tab + ' #password').val()!=$(tab + ' #password_confirmation').val())
      putError('password_confirmation','passwords are not equal')

    if(!error)
      return true;
    return false;
  }


/*
  SOCIALS
*/
  /**
  * ON FACEBOOK LINK CLICK
  * @copyright Oles Bolotniuk 
  * @since 15:06 - 26.11.2013
  **/
  $(page+'#fb').on('click', function(){

    if($(this).hasClass('disabled'))
      return;

    // GET STATUS
    FB.getLoginStatus(function(response) {

      // IF CONNECTED - FILL INPUT
      if (response.status == 'connected') {
      
        FB.api('/me', function(response) {
          // SEND AJAX - UPDATE USERS TABLE
          var send = {
            'social':'facebook',
            'id':response.id,
            'ajax':1
          }
          $.post('/ajax/addSocial',send);

          $(page+'#fb').find('.inner').html('added')
        });

      } else {
        // LOG IN
        FB.login(function(response) {
          if (response.authResponse) {
            FB.api('/me', function(response) {

              // SEND AJAX - UPDATE USERS TABLE
              var send = {
                'social':'facebook',
                'id':response.id,
                //'ajax':1
              }
              $.post('/ajax/addSocial',send);
              $(page+'#fb').find('.inner').html('added')
            });
          }
        }, {scope: ['email']} );
      }
    });
  });

  /**
  * LINKED IN BUTTON CLICK
  * @copyright Oles Bolotniuk
  * @since 15:07 - 26.11.2013
  **/
  $(page+'#li').on('click',function(){
    
    if($(this).hasClass('disabled'))
    return;

    IN.UI.Authorize().params({"scope":["r_fullprofile", "r_emailaddress","r_contactinfo"]}).place();
    IN.Event.on(IN, "auth", onLinkedInAuth);
  })

  function onLinkedInAuth(){
    IN.API.Profile("me").fields([ "id"]).result(displayProfiles);
  }

  function displayProfiles(profiles) {
    var member = profiles.values[0]; 
    
    var send = {
      'social':'linkedin',
      'id':member.id,
      'ajax':1
    }
    $.post('/ajax/addSocial',send);
    $(page+'#li').find('.inner').html('added')
  }

  /**
  * GOOGLE+ BUTTON CLICK
  **/
  $(page+'#gg').on('click', function(e){
    e.preventDefault();

    if($(this).hasClass('disabled'))
      return;

    gapi.client.setApiKey(GG_API_KEY);

    gapi.auth.authorize({
      client_id: GG_CLIENT_ID,
      scope: GG_SCOPES,
      immediate: false
    }, googleSignin);
  });

  function googleSignin (authResult) {
    gapi.client.load('plus', 'v1', googleApiClientLoaded);
  }

  function googleApiClientLoaded () {
    gapi.client.plus.people.get({userId: 'me'}).execute(googleHandleResponse);
  }

  function googleHandleResponse (user) {
    // SEND AJAX - UPDATE USERS TABLE
    var send = {
      'social': 'google',
      'id': user.id
    }

    $.post('/ajax/addSocial', send);
    $(page+'#gg').find('.inner').html('added')
  }
  /*
    END OF SOCIALS
  */


  // SAVE COMPANY BUTTON
  $(page+'.save').on('click', function(){

    if(saving)
      return;
    
    var btn = $(this);
    var ex = btn.html();

    if(!checkInputsCompany()){
      $('body').scrollTop($('.tabs').offset().top);
      return;
    }

    var send = $('#company_form').serialize();

    // GET SUBCATS
    var all_cats = '';
    $('.cat.active').each(function(){
      all_cats += $(this).data('id');
      all_cats += ',';
    });

    all_cats = all_cats.substr(0, all_cats.length-1);
    send +='&all_cats='+all_cats;

    // GET SUBCATS
    var subcats = '';
    $('.w_check.checked').each(function(){
      subcats += $(this).data('id');
      subcats += ',';
    });

    subcats = subcats.substr(0,subcats.length-1);
    send +='&subcats='+subcats;

    // GET MAIN CATS FOR CACHE
    var cats = '';
    $('.cat.active').each(function(){
      cats += $(this).find('span').html();
      cats += ',';
    });

    cats = cats.substr(0,cats.length-1);
    send +='&cats='+cats;

    // SEND ID OF COMPANY
    send += '&id='+id_company;

    // SENT COUNTRY FROM ... CUSTOMIZZZED SELECT
    send +='&country='+$('.cur .cc').data('code');

    // SENT STATE
    if($('.field.state').is(':visible'))
      send +='&state='+$('.cur .ss').html();
    else
      send +='&state=';

    saving = true;
    btn.html('checking');

    // SEND AJAX
    $.post('/ajax/saveCompany', send)
    .done(function(data) {
      btn.css('background-color','#37d5b9');
      btn.html('saved');

      setTimeout(function(){
        btn.css('background-color','#000');
        btn.html(ex);
        saving = false;
      }, 1000);

      // refresh availability
      if (data == 'ok'){
        $('.notification').addClass('hidden');
      } else {
        $('.notification').removeClass('hidden');
        $('.notification').html(data);
      }
    })
    .fail(function() {
      btn.css('background-color', '#000');
      btn.html(ex);
      saving = false;

      // FOCUS AND SCROLL TO FIRST ERROR ELEMENT
      $('body').scrollTop($('#' + data.errors[0].elem).offset().top - 150);
      $('#' + data.errors[0].elem).focus();

      $.each(data.errors, function(k, v) {
        putError(v.elem, v.message);
      });
    });
  });

  // Find out why click
  // should load view
  $('body').on('click', page+'.whynot', function(e){
    e.preventDefault();
    $('.reasons').fadeToggle();
  })


  /**
  * CHECK INPUTS IN COMPANY SETTINGS 
  * @copyright Oles Bolotniuk
  * @since 17:43 - 22.11.2013
  **/
  function checkInputsCompany(){
    error = null;
    // NAME CHECK
    if(el('name').val().length<2)
      putError('name','at least 2 symbols')

    // DISTRICT ADDRESS CHECK
    if(el('address').hasClass('error') || el('address').hasClass('loading'))
      putError('address','please, check your address')
    
    if(!error)
      return true;
    return false;
  }


  function el(id){
    return $(page+'#'+id);
  }

  function putError(id,message){
    var input = $(page+'#'+id);
    input.addClass('error');
    input.css('border','2px solid #f00');
    $(page+'#'+id+'-error').show();
    $(page+'#'+id+'-error').html(message);
    error = message;
  }

  /**
  * ON UPDATE MAP CLICK - SAVE NEW COORDS AND FIGURE OUT NEW POSITION BY GEOCODER
  * @copyright Oles Bolotniuk 
  * @since 14:12 - 22.11.2013
  **/
  $(page+".refresh").on('click',function(){
    var addr = "";
    var street = $("#address1").val()+' '+$("#address2").val();

    addr += street;

    if(addr!="") {
      geocoder = new google.maps.Geocoder();
      var country = $(page+'.select.country').find('.cur .cc').html().trim();
      var city = $(page+'#city').val();

      addr=country+' '+city+' '+addr;

       geocoder.geocode( { 'address': addr}, function(results, status) {

        if (status == google.maps.GeocoderStatus.OK) {
          coords=results[0].geometry.location;

        // IF NO MAP - INIT NEW
          if(!map)
          var map = initialize(coords.lat(), coords.lng(),zoom);

        var point = new google.maps.LatLng(coords.lat(), coords.lng());
        var Marker = new google.maps.Marker({position: point, map: map});
        markersArray.push(Marker);
        mapEvents();
        sendNewCoords(coords);
        }
      });
    } else {
      make_error("Вы не указали адрес", $("#adress").parent(),0);  
    }
  })


  /**
  * CUSTOM SELECT BLOCK
  * @copyright Oles Bolotniuk 
  * @since 13:46 - 25.11.2013
  **/

  $(page+".select").click(function(){
    $(this).toggleClass("active");
  });

  $("body").click(function(){
    $(".select").not(".hover").removeClass("active");
  })

  // adding hovers
  $(page+".select").hover(
    function(){
      $(this).addClass("hover");
    },
    function(){
      $(this).removeClass("hover");
    }
  )

  // COUNTRY
   $(page+".select.country a").on("click", function(e){
    var txt = $(this).html(),
      el = $(this).closest(".select"),
      code = $(this).data('code');
    el.find(".cur").html('<span class="cc" data-code="'+code+'">'+txt+'</span>');

    if(txt=='United States')
      $('.field.state').show();
    else
      $('.field.state').hide();
  });

  // STATE
  $(page+".select.state a").on("click", function(e){
    var txt = $(this).html(),
      el = $(this).closest(".select");
    el.find(".cur").html('<span class="ss">'+txt+'</span>');
  });

  $(page+".select.paymant-select a").on("click", function(e){
    var txt = $(this).html(),
      el = $(this).closest(".select"),
      code = $(this).data('code');

    el.find(".cur").html('<span class="ss">'+txt+'</span>');
    el.siblings('input').val(code);
  });

  /**
  * ADD EVENT TO MAP, ONCLICK, PLACE MARKER
  * @copyright Oles Bolotniuk
  * @since 14:27 - 22.11.2013
  **/
  function mapEvents(){
  google.maps.event.addListener(map, "click", function (e) { 
    
    if(markersArray.length)
    for(var i in markersArray)
      markersArray[i].setMap(null);

    var Marker = new google.maps.Marker({
      position: e.latLng,
      map: map
    });
    markersArray.push(Marker);
    sendNewCoords(e.latLng);
  });

  google.maps.event.addListener(map, 'zoom_changed', function() {
    zoom = map.getZoom();

    clearTimeout(zoomtimeout);
    zoomtimeout = setTimeout(function(){
      sendNewZoom();
    },1000)
  });
  }

  /**
  * SEND NEW COORDS TO PHP
  * @copyright Oles Bolotniuk 
  * @since 14:31 - 22.11.2013
  **/
  function sendNewCoords(location){
  var send = {
    'ajax':1,
    'x':location.lat(),
    'y':location.lng(),
    'id':id_company,
    'zoom':zoom
  }

  // SEND NEW COORDS TO PHP
  $.post('/ajax/setNewCoords', send);
  x = location.lat();
  y = location.lng();
  }


  /**
  * SEND NEW ZOOM TO PHP
  * @copyright Oles Bolotniuk 
  * @since 15:54 - 27.11.2013
  **/
  function sendNewZoom(location){
  var send = {
    'id':id_company,
    'zoom':zoom,
    'ajax':1
  }
  // SEND NEW ZOOM TO PHP
  $.post('/ajax/setNewZoom', send);
  }

  /**
  * INIT MAP AND PLACE MARKER
  * @copyright Oles Bolotniuk
  * @since 14:31 - 22.11.2013
  **/
  function initMap(){
  initialize();
  mapEvents();
  if(x && y){
    var point = new google.maps.LatLng(x, y);
    map.setCenter(point);
    var marker = new google.maps.Marker({position: point, map: map});
    markersArray.push(marker);
  }
  if(zoom)
    map.setZoom(parseInt(zoom));
  }

  // ON SETTINGS CATEGORY CLICK
  $(page+'.cat').on('click', function(){

  var cat = $(this).data('id');

  // IF ACTIVE
    if($(this).hasClass('active')){
      $(this).removeClass('active');
      showHideSub(false);

      if($(page+'.cat.active').length==0){
      $('.search-subcats-container').addClass('hidden');
      $(page+'.w_check').removeClass('checked');
      }
    }
    // IF INACTIVE
    else{
      $(this).addClass('active');
      $('.search-subcats-container').removeClass('hidden');
      showHideSub(true);
    }
  })

  /**
  * HIDE TYPES OF COMPANIES THAT HAVE NO SUBCATEGORIES
  * @copyright Oles Bolotniuk 
  * @since 11:06 - 11.12.2013
  **/
  function hideEmptySubs(){
    $('.search-subcats-container .row').show();
    $('.search-subcats-container .row').each(function(){
    if($(this).find('.w_check').length==$(this).find('.w_check.hidden').length)
      $(this).hide();
    })
  }

  // CALL TO INIT
  showHideSub(true);

  function showHideSub(show){
    var active_cats = [];

    $(page+'.cat.active').each(function(){
    active_cats.push($(this).data('id'))
    });

    $(page+'.w_check').each(function(){
    var d = $(this).attr('data-cats');

    if(d.indexOf(',')==-1){
    if(show==true && inArray(d,active_cats)){
      // show
      $(this).removeClass('hidden');
    }else if(show==false && !inArray(d,active_cats)){
      // hide
      $(this).addClass('hidden');
      $(this).removeClass('checked');
    }
    }else{
    var cats = d.split(',')
    var exist = false;

    for(var i in cats){
      if(inArray(cats[i],active_cats))
      exist = true;
    }

    if(show==true && exist)
      $(this).removeClass('hidden')
    else if(show==false && !exist){
      $(this).addClass('hidden');
      $(this).removeClass('checked');
    }


    }
  })
  hideEmptySubs();
  }

  function inArray(needle, haystack) {
    var length = haystack.length;
    for(var i = 0; i < length; i++) {
      if(haystack[i] == needle) return true;
    }
    return false;
  }

  // ON SETTINGS SUBCAT CLICK
  $(page+'.w_check').on('click', function(){
    $(this).toggleClass('checked');
  })

  
  /**
  * ON CHANGE DISTRICT ADDRESS {addr}.district2.com
  * @copyright Oles Bolotniuk
  * @since 15:46 - 22.11.2013
  **/
  var timer = null;
  $(page+'#address').on('keyup', function(){

    $(page+'#address').addClass('loading');
    $(page+'#address').css('border','2px solid #b0b0b0');

    var input = $(this);
    var a = $(this).val();

    a = a.replace(/[^A-z0-9\-]+/g,"");
    a = a.replace(/[\^\\]/,"");
    a = a.toLowerCase();
    $(this).val(a);

    clearTimeout(timer);
    timer = setTimeout(function(){

      var send = {
        'ajax':1,
        'address':a
      }

      // SEND AJAX TO CHECK COMPANY ADDRESS
      $.post('/ajax/checkAddress',send, function(data){
      $(page+'#address').removeClass('loading')
          if(data=="ok"){
            input.removeClass('error');
            $(page+'#address-error').hide();
            $(page+'#address').css('border','2px solid #1ab59a');
            input.addClass('done');
          }else{
            input.removeClass('done');
            input.addClass('error');
            $(page+'#address').css('border','2px solid #f00');
            $(page+'#address-error').show();
            $(page+'#address-error').html(data);
          }
      })
    },1500)
  })

  $(page+'#phone').on('keyup', function(){

    var a = $(this).val();

    a = a.replace(/[^()0-9\-]+/g,"");
    a = a.replace(/[\^\\]/,"");
    a = a.toLowerCase();
    $(this).val(a);
  })
  

  /**
  * ON KEYUP - HIDE ERROR MESSAGE ON EVERY INPUT
  * @copyright  
  * @since 
  **/
  $(page+'input').on('keyup', function(){
  var id = '#'+$(this).attr('id');

    if($(this).hasClass('error')){
      $(this).removeClass('error');
      $(page+id+'-error').hide();
      $(this).css('border','2px solid #b0b0b0');
    }
  })

  /**
  * ON CHANGE IMAGE CLICK
  * @copyright Oles Bolotniuk 
  * @since 14:57 - 25.11.2013
  **/
  $('.act.avatar').on('click', function(){
  $('#avatar-file').click();
  })

  $('.act.logo').on('click', function(){
  $('#logo-file').click();
  })

  $('.act.pic').on('click', function(){
  if(!fileloading)
    $('#pic-file').click();
  })


  /**
  * ON FILE CHANGE
  * @copyright Oles Bolotniuk 
  * @since 12:26 - 26.11.2013
  **/
  $('body').on('change', '#avatar-file', function(){
    readURL(this,'avatar');
    $('form.avatar').submit();
  });

  $('body').on('change', '#logo-file', function(){
    readURL(this,'logo');
    $('form.logo').submit();
  });

  $('body').on('change', '#pic-file', function(){
  if(addPic(this))
    ajaxFileUpload();
  });

  /**
  * READS UPLOAD PIC AND SHOWS PREVIEW IN THE #elem image
  * @param input,element id
  * @copyright Oles Bolotniuk
  * @since 16:18 - 25.11.2013
  **/
  function readURL(input,elem) {

    if (input.files && input.files[0]) {

      if (!input.files[0].type.match('image.*')){
      alert('not an image!');
      return false;
      }

      var reader = new FileReader();

      reader.onload = function (e) {
      console.log(e)

        $('#'+elem).attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
      return true;
    }
  }

  /**
  * ADD ITEM TO LIST AND PREVIEW UPLOADED IMAGE
  * @copyright Oles Bolotniuk 
  * @since 12:26 - 26.11.2013
  **/
  function addPic(input) {

    if (input.files && input.files[0] && input.files[0].type.match('image.*')) {
      var reader = new FileReader();

      reader.onload = function (e) {
      if($('#dummy').length>0)
        $('#dummy').remove();
        $('#sortable').append('<li class="pics-list" id="" data-id=""><span><i class="del"></i><img class="pics" src="'+e.target.result+'"></span></li>');
      }

      reader.readAsDataURL(input.files[0]);
      return true;
    }
  }

  /**
  * FUNCTION TO SEND PICTURE THROUGH AJAX
  * @copyright Oles Bolotniuk 
  * @since 12:02 - 26.11.2013
  **/
  function ajaxFileUpload() {
    $.ajaxFileUpload({
      url: $('form.pic').attr('action'),
      secureuri: false,
      fileElementId: 'pic-file',
      dataType: 'text',
      data: { 'ajax': 1, 'id': id_company },
      success: function (data, status) {
        if (typeof(data.error) != 'undefined') {
          console.log('data-error:' + data.error)
          console.log('data-message:' + data.msg)
        } else {
          $('#sortable li:last-child').attr('id','pic_' + data);
          $('#sortable li:last-child').attr('data-id', data);
          initSortable();
        }
      },
      error: function (data, status, e) {
        fileloading = false
      }
    });
    return false;
  } 

  /**
  * INIT SORTABLE PICTURES LIST
  * @copyright Oles Bolotniuk 
  * @since 12:25 - 26.11.2013
  **/
  function initSortable(){
    $('#sortable').sortable({
      tolerance: "intersect",
      stop: function (event, ui) {
        var sorted = $('#sortable').sortable( "serialize");
        sorted+= '&ajax=1';
        sorted+= '&id='+id_company;
        $.post('/ajax/sortPics/',sorted);
        console.log(sorted)
      }
    });
    $( "#sortable" ).disableSelection();
  }
  initSortable();

  /**
  * DELETE PIC
  * @copyright Oles Bolotniuk 
  * @since 12:30 - 26.11.2013
  **/
  $('body').on('click', 'i.del', function(){
  var id = $(this).closest('.pics-list').data('id');

  var send = {
    'id':id,
    'ajax':1,
    'company':id_company
  }

  $.post('/ajax/deletePic/',send, function(data){
    if(data=='ok'){
      $('#pic_'+id).fadeOut();
    }
  });
  });
});
