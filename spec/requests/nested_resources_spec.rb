require 'spec_helper'

feature 'Show project page via nested resources', r:true do
  let(:project) { Factory.create(:project) }

  before(:each) do
    scene1 = Factory.create(:scene, :project_id => project.id)
    scene2 = Factory.create(:scene, :project_id => project.id)
  end

  scenario 'only show scenes that belong to specific project' do
    # create a scene from different project
    other_project = Factory.create(:project)
    other_scene = Factory.create(:scene, :project_id => other_project.id)

    visit "/projects/#{project.id}/scenes"

    # one header tr and two scene tr = 3 total
    page.all(".table-striped tr").count.should == 3
  end
end
