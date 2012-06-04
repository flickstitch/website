require 'spec_helper'
include ControllerMacros

describe VideosController do
  let(:video) { Factory.create(:video) }

  before(:each) do
    Video.stub(:find).and_return(video)
  end

  context "logged in user" do
    login_user

    describe ".vote_up" do
      it "increase vote count by 1" do
        expect do
          get :vote_up, :id => video.id, :format => :json
        end.to change{ Vote.count }.by 1
      end

      it "increment video score by 1" do
        expect do
          get :vote_up, :id => video.id, :format => :json
        end.to change { video.score }.by 1
      end

      it "saves score to database" do
        get :vote_up, :id => video.id, :format => :json
        Video.first.score.should == video.score
      end

      it "returns json info about vote" do
        get :vote_up, :id => video.id, :format => :json
        json_response = JSON.parse(response.body)
        json_response['vote_on'].should == true
        json_response['votes_for'].should == 1
      end

    end

    describe ".vote_down" do
      it "vote should be false" do
        # create a vote before downvoting
        subject.current_user.vote_for(video)

        expect do
          get :vote_down, :id => video.id, :format => :json
        end.to change{ Vote.count }.by -1
      end

      it "lowers video score by 1" do
        expect do
          get :vote_down, :id => video.id, :format => :json
        end.to change { video.score }.by -1
      end

      it "saves score to database" do
        get :vote_down, :id => video.id, :format => :json
        Video.first.score.should == video.score
      end

      it "returns json info about vote" do
        get :vote_down, :id => video.id, :format => :json
        json_response = JSON.parse(response.body)
        json_response['vote_on'].should == false
        json_response['votes_for'].should == 0
      end
    end
  end

  context "user not logged in" do
    describe ".vote_up" do
      it "not allowed" do
        expect do
          get :vote_up, :id => video.id, :format => :json
        end.to change{ Vote.count }.by 0
        response.success?.should == false
      end
    end

    describe ".vote_down" do
      it "not allowed" do
        expect do
          get :vote_down, :id => video.id, :format => :json
        end.to change{ Vote.count }.by 0
        response.success?.should == false
      end
    end
  end

end
