$(document).ready(function() {

  function ProjectsViewModel() {
    var self = this;

    self.show_video_pane = ko.observable(false);
    self.show_select_video_pane = ko.observable(false);
    self.videos = ko.observableArray();
    self.video = ko.observable({name:'', 
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

      $.ajax({
        url: video_url,
        dataType: 'json',
        success: function(data, status, xhr) {
          video_and_comments = JSON.parse(xhr.responseText);
          console.log(video_and_comments);

          parsed_comments = JSON.parse(video_and_comments.comments);
          self.comments(parsed_comments);

          parsed_video = JSON.parse(video_and_comments.video);
          self.video(parsed_video);

          self.show_video_pane(true);
          self.show_select_video_pane(false);
        }
      })
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
});
