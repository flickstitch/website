class Scene < ActiveRecord::Base
  belongs_to :project
  has_many :videos

  def is_vote_time?(current_date)
    true
  end

  def is_submit_time?(current_date)
    current_date > self.start_date && current_date < self.end_date
  end

  def is_closed_time?(current_date)
    true
  end

  def is_unavailable_time?(current_date)
    true
  end

end
