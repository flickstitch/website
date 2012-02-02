class Video < ActiveRecord::Base
  belongs_to :user

  validates :video_url, :presence => true
  validates :user_id, :presence => true
  validate :from_youtube

  before_save :set_video_id, :set_thumbnail_url

  default_scope order('id desc')

  private

  # videos must be from youtube.com or vimeo.com
  def from_youtube
    uri = URI.parse(self.video_url)

    if uri.host.nil? || (!uri.host.include?('youtube.com') && !uri.host.include?('youtu.be'))
      errors.add(:video_url, "must be from youtube.com or vimeo.com")
    end
  end

  def set_video_id
    video_id = 0
    uri = URI.parse(self.video_url)

    if uri.host.include?('youtube.com')
      query = CGI.parse(uri.query)
      unless query['v'].empty?
        video_id = query['v'][0]
      end
    elsif uri.host.include?('youtu.be')
      # youtube video id's are 11 chars (12 cuz of the / char in path)
      if uri.path.length == 12
        video_id = uri.path[1..-1]
      end
    end

    if video_id == 0
      raise "cannot figure out video id for: #{self.video_url}"
    else
      self.video_id = video_id
    end
  end

  def set_thumbnail_url
    thumbnail_url = ''
    uri = URI.parse(self.video_url)

    if uri.host.include?('youtube.com') || uri.host.include?('youtu.be')
      self.thumbnail_url = "http://img.youtube.com/vi/#{self.video_id}/2.jpg"
    else
      raise "unable to parse thumbnail url for: #{self.video_url}"
    end
  end

end
