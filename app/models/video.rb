class Video < ActiveRecord::Base
  validates :video_url, :presence => true
  validate :from_youtube

  before_create :get_thumbnail_url
  default_scope order('id desc')

  private

  # videos must be from youtube.com or vimeo.com
  def from_youtube
    uri = URI.parse(self.video_url)

    if uri.host.nil? || (!uri.host.include?('youtube.com') && !uri.host.include?('youtu.be'))
      errors.add(:video_url, "must be from youtube.com or vimeo.com")
    end
  end

  def get_thumbnail_url
    uri = URI.parse(self.video_url)
    video_id = ''

    if uri.host.include?('youtube.com')
      query = CGI.parse(uri.query)
      video_id = query['v'][0]
    elsif uri.host.include?('youtu.be')
      video_id = uri.path[1..-1]
    else
      raise "youtube video could not be parsed. video url=#{self.video_url}"
    end

    self.thumbnail_url = "http://img.youtube.com/vi/#{video_id}/2.jpg"
  end

end
