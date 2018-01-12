var x = null;
var y = null;
var zoom = null;

$(document).ready(function(){

  var page = '.company ';

  $(page+'a').on('click', function(e){
    if( ($(this).attr('href')=='') || ($(this).attr('href')=='#') )
      e.preventDefault();
  })

  // TOOGLE TABS
  var $tabs = $('[data-tabs] a'),
      $tabsPanes = $('[data-tabs-panes] > div');

  $tabs.on('click', function(e) {
    e.preventDefault();

    var panesId = $(this).attr('href');

    $tabs.removeClass('active');
    $(this).addClass('active');

    $tabsPanes.hide();
    $(panesId).show();
  });

  // INIT MAP
  $('[href="#contacts"]').one('click', function() {
    initialize(x, y, zoom);      

    if(x && y){
      var point = new google.maps.LatLng(x, y);
      var marker = new google.maps.Marker({position: point, map: map});
    }

    google.maps.event.addListener(map, 'zoom_changed', function() {
      zoom = map.getZoom();
    });
  });

  /**
  *   FACEBOOK REPOST
  **/
  $('.repost-fb').on('click', function(e){
    e.preventDefault();
    var elem = $(this);

    // GET STATUS
    FB.getLoginStatus(function(response) {

      // IF CONNECTED - FILL INPUTS
      if (response.status === 'connected') {
      
      //checkPermissions();
      fb_repost(elem)

      } else {

      // LOG IN
         FB.login(function(response) {
         if (response.authResponse) {
          fb_repost(elem)
         }
       }, {scope: ['email']} );

      }
     });

  })

  /**
  *   SHARE IN FB
  **/
  function fb_repost(elem){
    var link = elem.data('url');
    if(elem.attr('href') && elem.attr('href')!='#')
      link = elem.attr('href');
    FB.ui({
      method: 'feed',
      link: link,
      caption: elem.data('text'),
      picture: elem.data('pic'),
      description: elem.data('description')
    }, function(response){ 
      // FB CALLBACK
      if(response){
        var social = 'fb';
        shareUpdate($(elem).data('id')+'-'+social,$(elem).data('id'),social);
      }
     });
  }

  /**
  *   CATCH TWITTER CALLBACK
  **/
  twttr.ready(function (twttr) {
    twttr.events.bind('tweet', function (event) {
      var social = 'tw';
      var elem = event.target;
      shareUpdate($(elem).attr('data-id')+'-'+social,$(elem).attr('data-id'),social);
    });
  })

  /**
  *   TWITTER SHARE
  **/
  $('.repost-tw').on('click', function(e){
    e.preventDefault();
    var link = $(this).data('url');

    var text = $(this).data('text');
    var url = "https://twitter.com/intent/tweet" + 
        "?url=" + encodeURIComponent(link) + 
        "&text=" + encodeURIComponent(text);
    $('a.repost-tw').attr('href',url);
  })

  /**
  *   GOOGLE PLUS SHARE
  **/
  $('.repost-gp').on('click', function(e){
    e.preventDefault();
    var social = 'gp';
    window.open($(this).attr('href'), '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');
    shareUpdate($(this).attr('data-id')+'-'+social,$(this).attr('data-id'),social);
  })
  /**
  *   LINKEDIN SHARE
  **/
  $('.repost-in').on('click', function(e){
    e.preventDefault();
    var social = 'in';
    window.open($(this).attr('href'),'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');
    shareUpdate($(this).attr('data-id')+'-'+social,$(this).attr('data-id'),social);
  })

  /**
  *   UPDATE NUMBER OF SHARES - INCREMENT ON SUCCESS
  **/
  function shareUpdate(element,id,social){

    var send = {
      'ajax':1,
      'id':id,
      'social':social
    }
    
    $.ajax({
      url: base_url+'ajax/shareCompany', 
      data: send,
      type: "POST",
      xhrFields: { withCredentials: true },
      crossDomain: true,
      success: function(data){
        if(data=='ok'){
          var votes = parseInt($('#'+element).html());
          $('#'+element).html(++votes);
        }
      }
    })
  }
});
