    var sec = 1000;
    /**
    *   UPDATE LAST ACTION FUNC
    *   TO SET USER ONLINE
    **/
    var up = setInterval(function(){
    	updateOnline();
    },40*sec);

	updateOnline();
    function updateOnline(){
        var send = { 'ajax':1};

        $.ajax({
            url: base_url+'ajax/updateOnline', 
            data: send,
            type: "POST",
            xhrFields: { withCredentials: true },
            crossDomain: true
        })
    }