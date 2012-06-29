$(document).ready(function() {

  function ProjectsViewModel() {
    this.videos = ko.observableArray();

    this.click_scene_menu = function(data, event) {
      var self = this;
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
  }

  ko.applyBindings(new ProjectsViewModel());
});
