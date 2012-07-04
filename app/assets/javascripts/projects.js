$(document).ready(function() {

  function ProjectsViewModel() {
    var self = this;

    self.videos = ko.observableArray();
    self.video = ko.observable({name:'', actors:'', created_at:'', video_url:''});
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
        }
      })

      //console.log(ko.toJSON(data));
      self.video(data);
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
