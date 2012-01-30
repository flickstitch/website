class Video < ActiveRecord::Base
  validates :video_url, :presence => true
  validate :from_youtube

  before_save :get_video_id, :get_thumbnail_url

  default_scope order('id desc')

  private

  # videos must be from youtube.com or vimeo.com
  def from_youtube
    uri = URI.parse(self.video_url)

    if uri.host.nil? || (!uri.host.include?('youtube.com') && !uri.host.include?('youtu.be'))
      errors.add(:video_url, "must be from youtube.com or vimeo.com")
    end
  end

  def get_video_id
    video_id = 0
    uri = URI.parse(self.video_url)

    if uri.host.include?('youtube.com')
      query = CGI.parse(uri.query)
      video_id = query['v'][0]
    elsif uri.host.include?('youtu.be')
      video_id = uri.path[1..-1]
    else
      raise "cannot figure out video id for: #{self.video_url}"
    end

    self.video_id = video_id
  end

  def get_thumbnail_url
    thumbnail_url = ''
    uri = URI.parse(self.video_url)

    if uri.host.include?('youtube.com') || uri.host.include?('youtu.be')
      thumbnail_url = "http://img.youtube.com/vi/#{self.video_id}/2.jpg"
    else
      raise "unable to parse thumbnail url for: #{self.video_url}"
    end

    self.thumbnail_url = thumbnail_url
  end

end
