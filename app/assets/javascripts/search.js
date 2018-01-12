$(document).ready(function(){

  var page = '.mainpage ';
  var input_timeout = null;
  var category_timeout = null;
  var CATEGORY_TIME = 500;
  var INPUT_TIME = 300;

  /**
    * CUSTOM SELECT BLOCK
    * @copyright Oles Bolotniuk 
    * @since 13:46 - 25.11.2013
    **/
    $('body').on('click', function(){
      if($('.search-hint').is(':visible') && !$('.search-hint').hasClass('hover'))
        $('.search-hint').addClass('hidden');
    })

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

    // LOCATION SELECT
   $(page+".select#location a").on("click", function(e){
        var txt = $(this).html(),
            el = $(this).closest(".select")
        el.find(".cur").html(txt);

        sendAndReceive();
    });

   // SHOW MORE / HIDE
   $(page+'.show_hide').on('click', function(e){
    e.preventDefault();

    if($(this).attr('data-action')=='1'){
      $('.search-subcats .subcats.short').removeClass('short');
      $(this).attr('data-action',0);
      $(this).html('Hide ^');
    }else{
      $('.search-subcats .subcats').addClass('short');
      $(this).attr('data-action',1);
      $(this).html('Show more');
    }

   })

  // ON CATEGORY CLICK
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
      showHideSub(true,true);
    }

    // CHECK ROWS
    var check = 0;
    $('.products .w_check').each(function(){
      if(!$(this).hasClass('hidden'))
        check++;
    })

    // SET TIMEOUT FOR AJAX
    clearTimeout(category_timeout);
    countdown('category_timeout',CATEGORY_TIME);
  })

  /**
  * HIDE TYPES OF COMPANIES THAT HAVE NO SUBCATEGORIES
  * @copyright Oles Bolotniuk 
  * @since 11:06 - 11.12.2013
  **/
  function hideEmptySubs(){
    $('.subcats .row').show();
    $('.subcats .row').each(function(){
      if($(this).find('.w_check').length==$(this).find('.w_check.hidden').length)
        $(this).hide();
    })
  }

  // ON SETTINGS SUBCAT CLICK
  $(page+'.w_check').on('click', function(){
    $(this).toggleClass('checked');
    clearTimeout(category_timeout);
      countdown('category_timeout',CATEGORY_TIME);
  })

  // CALL TO INIT
  showHideSub(true);

    function showHideSub(show,check){

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
          if(check) $(this).addClass('checked');
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

        if(show==true && exist){
          $(this).removeClass('hidden')
          if(check) $(this).addClass('checked');
        }
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


    // SELECT ALL
    $('.select_all').on('click', function(e){
      e.preventDefault();
      $('.w_check').addClass('checked');
      countdown('category_timeout',CATEGORY_TIME);
    })

    // CLEAR ALL
    $('.clear_all').on('click', function(e){
      e.preventDefault();
      $('.w_check').removeClass('checked');
      countdown('category_timeout',CATEGORY_TIME);
    }) 

  /**
  * ON KEYUP - LOAD HINTS
  * @copyright Oles Bolotniuk
  * @since 12:19 - 28.11.2013
  **/
  $(page+'.stripe-yellow #search-input').on('keyup', function(e){
    $('.search-hint').addClass('hidden');
    clearTimeout(input_timeout)

    //e.which!=8 &&  backspace
    if(e.which != 13 && e.which != 46 && $(this).val() != ''){
      clearTimeout(input_timeout);
      input_timeout = setTimeout(function(){
        var send = {
          'ajax':1,
          'text':$(page+'.stripe-yellow #search-input').val()
        };
        $.post('/ajax/getHints', send, function(data){
          if(data){
            // data = JSON.parse(data);
            $('.search-hint').removeClass('hidden');
            $('.hints').html(data.html);
          }
        })
      },INPUT_TIME)
    }
  })

  $(page+'.search-hint').hover(function(){
    $(this).addClass('hover');
  }, function(){
    $(this).removeClass('hover');
  })

  // SEARCH FORM SUBMIT
  $(page+'#search-form').on('submit', function(e){
    e.preventDefault();

    clearTimeout(input_timeout);
    sendAndReceive();
    $('html, body').animate({
      scrollTop: $("#search").offset().top - $('.page-head').height()
    }, 1000);
  })

  // SEARCH BUTTON CLICK
  $(page+'.stripe-yellow #search-button').on('click', function(){
    $(page+'.stripe-yellow #search-form').submit();
  })

  // ON HINT MORE CLICK
  $('body').on('click', page+'.more', function(e){
    e.preventDefault();
    $('.search-hint').addClass('hidden');
    $(page+'.stripe-yellow #search-form').submit();
  })

  /**
  * SEND FILTERS AND RECEIVE COMPANIES
  * @copyright Oles Bolotniuk
  * @since 15:11 - 28.11.2013
  **/
  function sendAndReceive(shown,limit){

    var send = {};

    send = {
      'text':$('.stripe-yellow #search-input').val(),
      'order':$(page+'a.csort.active').data('order'),
    }

    if(limit)
      send['limit'] = limit;
    else
      send['limit'] = max;

    // CONCAT ALL CATEGORIES AND SUBCATS
    var subcats = '';
    $('.w_check.checked').each(function(){
      if($(this).is(':visible'))
        subcats += $(this).data('id') + ',';
    })
    subcats = subcats.substr(0,subcats.length-1);
    if(subcats.length>0)
      send['subcats'] = subcats;

    var cats = '';
      $('.cat.active').each(function(){
        cats += $(this).data('id') + ',';
      })
      cats = cats.substr(0,cats.length-1);
    if(cats.length>0)
      send['cats'] = cats;

    if(shown && shown.length>0)
      // send['shown'] = shown;
      send['offset'] = shown.split(',').length;

    var s = $.trim($('#location .cur').html());
    if(s!='All')
      send['state'] = s;

    /* HISTORY PUSH */
    var filters = {
      order:send.order,
      limit:send.limit,
      cats:cats,
      subcats:send.subcats,
      text:send.text,
      state:send.state
    }

    for(var i in filters)
      if(filters[i]=='' || (typeof filters[i]=='undefined'))
        delete filters[i];

    //History.pushState(filters, document.title, '?'+$.param(filters)+'#search')

    /* END OF HISTORY PUSH */

    if(!shown){
      $('.midloader').show();
      $('.cards-cont').hide();
    }

    $.ajax({
      url: base_url+'ajax/filterCompanies', 
      data: send,
      type: "POST",
      xhrFields: { withCredentials: true },
      crossDomain: true,
      success: function(data){
        // data = JSON.parse(data);

        if(shown){
          $('.cards-cont').append(data.html);
        }else
          $('.cards-cont').html(data.html);

        $('.midloader').fadeOut(function(){
          $('.cards-cont').fadeIn();
        });

        filters.limit = $('.card').length;

        window.history.pushState(filters, document.title, '?'+$.param(filters)+'#search');

        if(data.all==data.count)
          $(page+'.load_more').fadeOut();
        else
          $(page+'.load_more').fadeIn();
      }
    });
  }

  window.addEventListener("popstate", function(e) {
    if(e.state){
      window.history.replaceState(e.state, document.title, '?'+$.param(e.state)+'#search');
      window.location.reload();
    }
  });



  /**
  * LOAD MORE BUTTON
  * @copyright Oles 
  * @since 16:17 - 28.11.2013
  **/
    $(page+'.load_more').on('click', function(e){
        e.preventDefault();

        var shown = '';
        $('.card').each(function(){
          shown += $(this).data('id')+',';
        })
        shown = shown.substr(0,shown.length-1)
        sendAndReceive(shown)
    })

    /**
    * SORT BUTTON
    * @copyright Oles Bolotniuk 
    * @since 16:16 - 28.11.2013
    **/
    $(page+'a.csort').on('click', function(e){
        e.preventDefault();

        if($(this).hasClass('active'))
            return;

        $('a.csort').removeClass('active');
        $(this).addClass('active');

        sendAndReceive(null,$('.card').length);
    })

    /**
    * TIMEOUT INTO GLOBAL VARIABLE
    * @copyright Oles Bolotniuk 
    * @since 17:39 - 28.11.2013
    **/
    function countdown(v,timeout,params){
        clearTimeout(window[v]);
      window[v] = setTimeout(function(){
        sendAndReceive(params);
      },timeout);
    }

    /**
    * IF WE GOT CATS FROM $_GET - SHOW ACTIONS DIV
    * @copyright Oles Bolotniuk 
    * @since 18:11 - 29.11.2013
    **/
    function checkActions(){
    if( $('.w_check.checked').length>0 )
          $('.actions').fadeIn();
    }
    checkActions();

})