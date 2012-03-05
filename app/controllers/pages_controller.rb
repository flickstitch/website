class PagesController < ApplicationController

  def home
    @videos = Video.all
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def terms
  end

  # temporary actions that need to be removed
  def mockscene1
  end

  def mockscene2
  end

  def mockvote
  end

  def mocksubmit
    @video = Video.new
  end

  def mocknone
  end
end
