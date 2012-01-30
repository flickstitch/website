class Video < ActiveRecord::Base
  validates :video_url, :presence => true
end
