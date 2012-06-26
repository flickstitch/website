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

  def landing
    render :layout => 'landing'
  end

end
