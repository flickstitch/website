require "spec_helper"

describe ScenesController do
  describe "routing" do

    it "routes to #index" do
      get("/scenes").should route_to("scenes#index")
    end

    it "routes to #new" do
      get("/scenes/new").should route_to("scenes#new")
    end

    it "routes to #show" do
      get("/scenes/1").should route_to("scenes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/scenes/1/edit").should route_to("scenes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/scenes").should route_to("scenes#create")
    end

    it "routes to #update" do
      put("/scenes/1").should route_to("scenes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/scenes/1").should route_to("scenes#destroy", :id => "1")
    end

  end
end
