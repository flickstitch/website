class Scene < ActiveRecord::Base
  belongs_to :project
  has_many :videos
  validates :project_id, :presence => true

  def is_vote_time?(current_date)
    adjusted_current_date = current_date - self.days_in_scene.days
    adjusted_current_date > self.start_date && adjusted_current_date < self.end_date + 1.day
  end

  def is_submit_time?(current_date)
    current_date > self.start_date && current_date < self.end_date + 1.day
  end

  def is_closed_time?(current_date)
    current_date > self.end_date + 2.day && !self.is_vote_time?(current_date)
  end

  def is_unavailable_time?(current_date)
    current_date < self.start_date
  end

  def days_in_scene
    (self.end_date - self.start_date).to_i + 1
  end

  # order by score
  def videos_by_score
    # videos is an array at this point, use array sorting
    self.videos.sort_by{ |v| v.score }.reverse
  end
end
