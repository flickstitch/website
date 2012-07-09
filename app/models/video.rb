require 'open-uri'

class Video < ActiveRecord::Base
  # thumbs_up gem
  acts_as_voteable

  acts_as_commentable

  belongs_to :user
  belongs_to :scene

  validates :video_url, :presence => true
  validates :user_id, :presence => true
  validates :scene_id, :presence => true
  validates_length_of :name, :minimum => 2, :maximum => 80, :allow_blank => true
  validate :from_accepted_site

  before_save :set_video_id, :set_thumbnail_url

  default_scope where(:visible => true).order('id desc')

  def upvote_by_user(current_user)
    current_user.clear_votes self
    current_user.vote_for(self)
    upscore
  end

  def downvote_by_user(current_user)
    current_user.clear_votes self
    downscore
  end

  def self.with_scene_id(scene_id)
    where(:scene_id => scene_id)
  end

  def comment_threads_by_date
    comment_threads(:include => :users).order("created_at DESC")
  end

  def from_youtube?
    uri = URI.parse(self.video_url)
    uri.host.include?('youtube.com') || uri.host.include?('youtu.be')
  end

  def from_vimeo?
    uri = URI.parse(self.video_url)
    uri.host.include?('vimeo.com')
  end

  private
  
  def upscore
    self.score += 1
    save!
  end

  def downscore
    self.score -= 1
    save!
  end

  # videos must be from youtube.com or vimeo.com
  def from_accepted_site
    uri = URI.parse(self.video_url)

    if uri.host.nil? || (%w[youtube.com youtu.be vimeo.com player.vimeo.com].include?(uri.host.sub('www.', '')) == false)
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
    elsif uri.host.include?('vimeo.com')
      video_id = get_vimeo_video_id(uri)
    end

    if video_id == 0
      raise "cannot figure out video id for: #{self.video_url}"
    else
      self.video_id = video_id
    end
  end

  def get_vimeo_video_id(uri)
    video_id = ''
    uri.to_s.split('/').each do |text|
      video_id = text if text.match(/\d+/)
    end

    video_id
  end

  def set_thumbnail_url
    thumbnail_url = ''
    uri = URI.parse(self.video_url)

    if uri.host.include?('youtube.com') || uri.host.include?('youtu.be')
      self.thumbnail_url = "http://img.youtube.com/vi/#{self.video_id}/2.jpg"
    elsif uri.host.include?('vimeo.com')
      self.thumbnail_url = get_vimeo_thumbnail_url(video_id)
    else
      raise "unable to parse thumbnail url for: #{self.video_url}"
    end
  end

  def get_vimeo_thumbnail_url(video_id)
    # API call
    vimeo_video_json_url = "http://vimeo.com/api/v2/video/%s.json" % video_id
    # Parse the JSON and extract the thumbnail_large url
    thumbnail_image_location = JSON.parse(open(vimeo_video_json_url).read).first['thumbnail_large'] rescue nil
    thumbnail_image_location
  end

end
