class VideosController < ApplicationController
  # cancan
  load_and_authorize_resource

  # GET /videos
  # GET /videos.json
  def index
    if user_signed_in? && (current_user.has_role?(:admin) || current_user.has_role?(:manager))
      @videos = Video.all

      respond_to do |format|
        format.json { render :nothing => true }
        format.html # index.html.erb
      end
    else
      raise CanCan::AccessDenied.new("Not authorized!")
    end
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    @video = Video.find(params[:id])
    @comments = @video.comment_threads.order("created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.json
  def new
    @video = Video.new
    @scene = Scene.find(params[:scene_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
    @scene = Scene.find(@video.scene_id)
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(params[:video])
    @scene = Scene.find(params[:video][:scene_id])

    @video.scene = @scene
    @video.user = current_user

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render json: @video, status: :created, location: @video }
      else
        format.html { render action: "new" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.json
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def vote_up
    @video = Video.find(params[:id])

    respond_to do |format|
      format.json do
        begin
          current_user.clear_votes @video
          current_user.vote_for(@video)
          render :json => { :vote_on => true, :votes_for => @video.votes_for }, :status => 200
        rescue
          render :nothing => true, :status => 400
        end
      end
    end
  end

  def vote_down
    @video = Video.find(params[:id])

    respond_to do |format|
      format.json do
        begin
          current_user.clear_votes @video
          current_user.vote_against(@video)
          render :json => { :vote_on => false, :votes_for => @video.votes_for }, :status => 200
        rescue
          render :nothing => true, :status => 400
        end
      end
    end
  end

  def add_comment
    video = Video.find(params[:id])
    text = params[:comment]
    comment = Comment.build_from(video, current_user.id, text)

    respond_to do |format|
      format.json do
        if comment.save
          comment_partial = render_to_string(:template => 'comments/_comment.html.haml', :locals => { :comment => comment})
          render :json => { :text => comment_partial }, :status => 200
        else
          render :json => { :text => comment.errors.full_messages.join('<br />') }, :status => 400
        end
      end
    end
  end

end
