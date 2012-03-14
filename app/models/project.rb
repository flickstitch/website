class Project < ActiveRecord::Base
  has_many :scenes

  def self.latest
    self.order('id desc').first
  end

  def scenes_by_date
    self.scenes.order('start_date asc')
  end
end
