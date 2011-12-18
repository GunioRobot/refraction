$(document).ready(function() {
   $('.close').click(
        function(){
        $('.alert-message').slideUp();
        }
    );

    $(function () {
        //$('.comments_counter').each(function(){alert($(this).attr('class'));});
      $('.comments_counter').each(function(){
          update_comments_counter($(this).attr('id'),$(this).attr('tweet_id'),$(this).attr('base_uri'));
      });

        //update_comments_counter();

    });

    function update_comments_counter(id,tweet_id,base_uri){
        $.getScript('/tweets/remote_comments_counter.js?id='+id+'&tweet_id='+tweet_id+'&base_uri='+base_uri);
    }

    //$('.comments_counter').load('/ssdf.js');
});

