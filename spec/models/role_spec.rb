require 'spec_helper'

describe Role do

  describe "guests have limited access" do
    let(:guest) { nil }

    it "can view videos" do
      ability = Ability.new(guest)
      ability.can?(:read, Video).should == true
    end

    it "cannot create videos" do
      ability = Ability.new(guest)
      ability.can?(:create, Video).should == false
    end
  end

  describe "members" do
    let(:user) { Factory.create(:user) }

    it 'can add videos' do
      ability = Ability.new(user)
      ability.can?(:create, Video).should == true
    end

    it 'can edit owned videos' do
      ability = Ability.new(user)
      owned_vid = Factory.create(:video, :user => user)
      ability.can?(:manage, Video).should == true
    end

    it "cannot edit someone else's video" do
      
    end
    
  end

end
