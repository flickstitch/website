$(document).ready(function() {

  function ProjectsViewModel() {
    var self = this;

    self.videos = ko.observableArray();
      var self = this;
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
