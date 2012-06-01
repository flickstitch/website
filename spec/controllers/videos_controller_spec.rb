require 'spec_helper'
include ControllerMacros

describe VideosController do
  let(:video) { Factory.create(:video) }
  describe ".vote_up" do
    # vote tests require a logged in user
    login_user

    before(:each) do
      Video.stub(:find).and_return(video)
    end

    it "increase vote count by 1" do
      expect do
        get :vote_up, :id => video.id, :format => :json
      end.to change{ Vote.count }.by 1
    end

    it "returns json info about vote" do
      get :vote_up, :id => video.id, :format => :json
      json_response = JSON.parse(response.body)
      json_response['vote_on'].should == true
      json_response['votes_for'].should == 1
    end
  end

  describe ".vote_down" do
    # vote tests require a logged in user
    login_user

    before(:each) do
      Video.stub(:find).and_return(video)
    end

    it "vote should be false" do
      get :vote_down, :id => video.id, :format => :json
      Vote.first.vote.should == false
    end

    it "returns json info about vote" do
      get :vote_down, :id => video.id, :format => :json
      json_response = JSON.parse(response.body)
      json_response['vote_on'].should == false
      json_response['votes_for'].should == 0
    end
  end

end
