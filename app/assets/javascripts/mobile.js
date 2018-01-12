$(document).ready(function(){

  // ON CAT CLICK
  $('.mobile-search li.cat').on('click', function(){

    var cat = $(this).data('id');

    // IF ACTIVE
    if($(this).hasClass('active')){
      $(this).removeClass('active');
      mobileSub(false);

      if($('.mobile-search .cat.active').length==0){
        $('.mobile-search .subcats-container').addClass('hidden');
        $('.mobile-search .w_check').removeClass('checked');
      }

    }
    // IF INACTIVE
    else{
      $(this).addClass('active');
      $('.mobile-search .subcats-container').removeClass('hidden');
      mobileSub(true,true);
    }
  })

  /**
  * HIDE TYPES OF COMPANIES THAT HAVE NO SUBCATEGORIES
  * @copyright Oles Bolotniuk 
  * @since 11:06 - 11.12.2013
  **/
  function hideEmptySubs(){
      $('.mobile-search .subcats .sub').show();
      $('.mobile-search .subcats .sub').each(function(){
        if($(this).find('.sli').length==$(this).find('.sli.hidden').length)
          $(this).hide();
      })
  }

  // ON FORM SUBMIT 
  $('.mobile-search form').on('submit', function(e){
    e.preventDefault();
    search();
  })

  // ON SEARCH CLICK
  $('.mobile-search i#search-button').on('click', function(){
    search();
  })

  // ON SEARCH BUTTON CLICK
  $('.m-search').on('click', function(e){
    e.preventDefault();
    search();
  })

  // SELECT ALL
  $('.m-select-all').on('click', function(e){
    e.preventDefault();
    $('.dk .subcats .w_check').addClass('checked');
  })

  // CLEAR ALL
  $('.m-clear-all').on('click', function(e){
    e.preventDefault();
    $('.dk .subcats .w_check').removeClass('checked');
  })

  $('.mobile-search .w_check').on('click', function(){
    $(this).toggleClass('checked')
  })

  mobileSub(true);
    function mobileSub(show,check){

      var active_cats = [];

      $('.mobile-search .cat.active').each(function(){
        active_cats.push($(this).data('id'))
      });

      $('.mobile-search .w_check').each(function(){
      var d = $(this).attr('data-cats');

      if(d.indexOf(',')==-1){
        if(show==true && inArray(d,active_cats)){
          // show
          $(this).closest('.sli').removeClass('hidden');
          if(check) $(this).addClass('checked');
        }else if(show==false && !inArray(d,active_cats)){
          // hide
          $(this).closest('.sli').addClass('hidden');
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
          $(this).closest('.sli').removeClass('hidden')
          if(check) $(this).addClass('checked');
        }
        else if(show==false && !exist){
          $(this).closest('.sli').addClass('hidden');
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

  // SEARCH IT!
  function search(){

    var send = {};

    var text = $('.mobile-search #search-input').val();
    if(text.length>0)
      send['text'] = text;

    send['order'] = 'date';

    // CONCAT ALL CATEGORIES AND SUBCATS
    var subcats = '';
    $('.mobile-search .w_check.checked').each(function(){
      if($(this).is(':visible'))
        subcats += $(this).data('id') + ',';
    })
    subcats = subcats.substr(0,subcats.length-1);
    if(subcats.length>0)
      send['subcats'] = subcats;

    var cats = '';
      $('.mobile-search .cat.active').each(function(){
        cats += $(this).data('id') + ',';
      })
      cats = cats.substr(0,cats.length-1);
    if(cats.length>0)
      send['cats'] = cats;

    var query = '?';
    for(var i in send)
      query += i+'='+send[i]+'&';
    query = query.substr(0,query.length-1);

    // if seach query same as previous simply remove search pannel (added by Bodik 10.12)
    var newUrl = base_url+query+'#search';
    if(window.location.href == newUrl){
      $("#js-mobile-search").click();
    }else window.location.href = newUrl;
  }

})