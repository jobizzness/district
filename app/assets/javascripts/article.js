$(document).ready(function(){

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

    var url = document.URL;
    if(url.substr(-1,1)!='/')
        url+='/';

    /**
    *   SHARE IN FB
    **/
    function fb_repost(elem){
        var link = url;
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

    function countShares(){
        var query = 'SELECT share_count, like_count, comment_count, total_count FROM link_stat WHERE url="'+url+'"';
        $.get( "https://api.facebook.com/method/fql.query?format=json&query="+query, function( data ) {
            alert(data[0]['share_count']);
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
    function shareUpdate(element, article, social) {

        var send = {
            'article': article,
            'social': social
        }

        $.post('/blog/ajax/share', send, function() {
            var votes = parseInt($('#'+element).html());
            $('#'+element).html(++votes);
        });
    }

});
