$(document).ready(function() {

  function ProjectsViewModel() {
    var self = this;

    self.show_video_pane = ko.observable(false);
    self.show_select_video_pane = ko.observable(false);
    self.videos = ko.observableArray();
    self.video = ko.observable({id:'',
                                name:'', 
                                actors:'', 
                                created_at:'', 
                                video_url:'', 
                                embed_url:'', 
                                from_vimeo:'', 
                                from_youtube:''});
    self.comments = ko.observableArray();

    self.click_scene_menu = function(data, event) {
      url = event.delegateTarget.href;

      $.ajax({
        url: url,
        dataType: 'json',
        error: function(response, status) {
        },
        success: function(data, status, xhr) {
          parsed_videos = JSON.parse(xhr.responseText);
          self.videos(parsed_videos);

          self.show_video_pane(false);
          self.show_select_video_pane(true);
        }
      })
    }

    self.click_video_menu = function(data, event) {
      var video_id = data.id;
      var video_url = "/videos/" + video_id;

      // video details
      $.ajax({
        url: video_url,
        dataType: 'json',
        success: function(data, status, xhr) {
          video_and_comments = JSON.parse(xhr.responseText);

          parsed_comments = JSON.parse(video_and_comments.comments);
          self.comments(parsed_comments);

          parsed_video = JSON.parse(video_and_comments.video);
          self.video(parsed_video);

          self.show_video_pane(true);
          self.show_select_video_pane(false);
        }
      });

      // comments
      $.ajax({
        url: '/videos/' + video_id + '/comments',
        dataType: 'json',
        success: function(data, status, xhr) {
          $('#comments').html(data.text);
        }
      });

      set_form_video_id(video_id);
    }
  }

  ko.bindingHandlers.fade_videos_in = {
    update: function(element, valueAccessor) {
      ko.utils.unwrapObservable(valueAccessor());
      $(element).css('display', 'none');
      $(element).fadeIn();
    }
  }

  ko.applyBindings(new ProjectsViewModel());

  // used by rails remote form submit to set correct video_id
  var set_form_video_id = function(video_id) {
    $('input#video_id').attr('value', video_id);
  }


  // show comments as they are added
  $('#comment_form').bind('ajax:complete', function(e, data, textStatus, jqHXR) {
    // clear the comment box
    $('#comment').val('')
    commentJson = $.parseJSON(data.responseText)
    if(textStatus == "success") {
      $("<div id='comment'>" + commentJson.text + '</div><hr />').hide().prependTo('#comments').fadeIn()
    }
    else {
      $("<div class='comment_error'>" + commentJson.text + '</div><hr />').hide().prependTo('#comments').fadeIn()
    }
  })
});
