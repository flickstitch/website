require 'spec_helper'
include ControllerMacros

describe UsersController do

  before(:each) do
    User.destroy_all
  end

  login_user

  it "should not be ok" do
    { :delete => "/users" }.should_not be_routable
  end

end
