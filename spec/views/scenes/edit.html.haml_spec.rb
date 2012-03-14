require 'spec_helper'

describe "scenes/edit" do
  before(:each) do
    @scene = assign(:scene, stub_model(Scene,
      :name => "MyString",
      :desc => "MyText"
    ))
  end

  it "renders the edit scene form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => scenes_path(@scene), :method => "post" do
      assert_select "input#scene_name", :name => "scene[name]"
      assert_select "textarea#scene_desc", :name => "scene[desc]"
    end
  end
end
