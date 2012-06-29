$(document).ready(function() {

  function ProjectsViewModel() {
    var self = this;

    self.videos = ko.observableArray();
    self.video = ko.observable({name:'', actors:'', created_at:'', video_url:''});

    self.click_scene_menu = function(data, event) {
      url = event.delegateTarget.href;

      $.ajax({
        url: url,
        dataType: 'json',
        complete: function(response, status) {
          parsed_videos = JSON.parse(response.responseText);
          self.videos(parsed_videos);
        }
      })
    }

    self.click_video_menu = function(data, event) {
      var video_id = data.id;
      //var video_url = "/videos/" + video_id;

      //$.ajax({
        //url: video_url,
        //dataType: 'json',

      console.log(ko.toJSON(data));
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
