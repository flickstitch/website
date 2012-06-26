require 'spec_helper'

feature 'Show project page via nested resources' do
  let(:project) { Factory.create(:project) }

  scenario 'only show scenes that belong to specific project' do
    Factory.create(:scene, :project_id => project.id)
    Factory.create(:scene, :project_id => project.id)
    # create a scene from different project
    other_project = Factory.create(:project)
    other_scene = Factory.create(:scene, :project_id => other_project.id)

    visit "/projects/#{project.id}/scenes"

    # one header tr and two scene tr = 3 total
    page.all(".table-striped tr").count.should == 3
  end

  scenario 'only show videos that belong to a specific scene' do
    scene = Factory.create(:scene, :project_id => project.id)
    Factory.create(:video, :scene_id => scene.id)
    Factory.create(:video, :scene_id => scene.id)
    # create a video from different scene
    other_scene = Factory.create(:scene)
    other_video = Factory.create(:video, :scene_id => other_scene.id)

    visit "/scenes/#{scene.id}/videos"

    page.all(".videos tr").count.should == 2
  end
end
