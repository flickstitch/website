require 'spec_helper'

describe Scene do

  context 'not an edge date' do
    before(:all) do
      @project = Factory.create(:project)
      @scene1 = Factory.create(:scene, project:@project, name:'s1', desc:'p1:s1' \
                               , start_date:'2012-03-04', end_date:'2012-03-10')
      @scene2 = Factory.create(:scene, project:@project, name:'s2', desc:'p1:s2' \
                               , start_date:'2012-03-11', end_date:'2012-03-17')
      @scene3 = Factory.create(:scene, project:@project, name:'s3', desc:'p1:s3' \
                               , start_date:'2012-03-18', end_date:'2012-03-24')
      @scene4 = Factory.create(:scene, project:@project, name:'s4', desc:'p1:s4' \
                               , start_date:'2012-03-25', end_date:'2012-03-31')
      @scene5 = Factory.create(:scene, project:@project, name:'s5', desc:'p1:s5' \
                               , start_date:'2012-04-01', end_date:'2012-04-07')
      @today = DateTime.parse('2012-03-19')
    end

    after(:all) do
      [Scene, Project, User, Video].each do |a|
        a.destroy_all
      end
    end

    describe "scene#is_closed_time?" do
      it 'true for dates that are past' do
        @scene1.is_closed_time?(@today).should == true
        @scene2.is_closed_time?(@today).should == false
        @scene3.is_closed_time?(@today).should == false
        @scene4.is_closed_time?(@today).should == false
        @scene5.is_closed_time?(@today).should == false
      end
    end

    describe "scene#is_vote_time?" do
      it 'true if date one period before start and end' do
        @scene1.is_vote_time?(@today).should == false
        @scene2.is_vote_time?(@today).should == true
        @scene3.is_vote_time?(@today).should == false
        @scene4.is_vote_time?(@today).should == false
        @scene5.is_vote_time?(@today).should == false
      end
    end

    describe "scene#is_submit_time?" do
      it 'true if date between start and end' do
        @scene1.is_submit_time?(@today).should == false
        @scene2.is_submit_time?(@today).should == false
        @scene3.is_submit_time?(@today).should == true
        @scene4.is_submit_time?(@today).should == false
        @scene5.is_submit_time?(@today).should == false
      end
    end

    describe "scene#is_unavailable_time?" do
      it 'true if date between start and end' do
        @scene1.is_unavailable_time?(@today).should == false
        @scene2.is_unavailable_time?(@today).should == false
        @scene3.is_unavailable_time?(@today).should == false
        @scene4.is_unavailable_time?(@today).should == true
        @scene5.is_unavailable_time?(@today).should == true
      end
    end
  end

  context 'end edge date (date falls on end_date)' do
    before(:all) do
      @project = Factory.create(:project)
      @scene1 = Factory.create(:scene, project:@project, name:'s1', desc:'p1:s1' \
                               , start_date:'2012-03-04', end_date:'2012-03-10')
      @scene2 = Factory.create(:scene, project:@project, name:'s2', desc:'p1:s2' \
                               , start_date:'2012-03-11', end_date:'2012-03-17')
      @scene3 = Factory.create(:scene, project:@project, name:'s3', desc:'p1:s3' \
                               , start_date:'2012-03-18', end_date:'2012-03-24')
      @scene4 = Factory.create(:scene, project:@project, name:'s4', desc:'p1:s4' \
                               , start_date:'2012-03-25', end_date:'2012-03-31')
      @scene5 = Factory.create(:scene, project:@project, name:'s5', desc:'p1:s5' \
                               , start_date:'2012-04-01', end_date:'2012-04-07')
      @edge_today = DateTime.parse('2012-03-17')
    end

    after(:all) do
      [Scene, Project].each do |a|
        a.destroy_all
      end
    end

    describe "scene#is_closed_time?" do
      it 'true for dates that are past' do
        @scene1.is_closed_time?(@edge_today).should == false
        @scene2.is_closed_time?(@edge_today).should == false
        @scene3.is_closed_time?(@edge_today).should == false
        @scene4.is_closed_time?(@edge_today).should == false
        @scene5.is_closed_time?(@edge_today).should == false
      end
    end

    describe "scene#is_vote_time?" do
      it 'true if date one period before start and end' do
        @scene1.is_vote_time?(@edge_today).should == true
        @scene2.is_vote_time?(@edge_today).should == false
        @scene3.is_vote_time?(@edge_today).should == false
        @scene4.is_vote_time?(@edge_today).should == false
        @scene5.is_vote_time?(@edge_today).should == false
      end
    end

    describe "scene#is_submit_time?" do
      it 'true if date between start and end' do
        @scene1.is_submit_time?(@edge_today).should == false
        @scene2.is_submit_time?(@edge_today).should == true
        @scene3.is_submit_time?(@edge_today).should == false
        @scene4.is_submit_time?(@edge_today).should == false
        @scene5.is_submit_time?(@edge_today).should == false
      end
    end

    describe "scene#is_unavailable_time?" do
      it 'true if date between start and end' do
        @scene1.is_unavailable_time?(@edge_today).should == false
        @scene2.is_unavailable_time?(@edge_today).should == false
        @scene3.is_unavailable_time?(@edge_today).should == true
        @scene4.is_unavailable_time?(@edge_today).should == true
        @scene5.is_unavailable_time?(@edge_today).should == true
      end
    end
  end

  describe ".videos_by_score" do
    it 'returns list of videos ordered by score' do
      user = Factory.create(:user)
      scene = Factory.create(:scene)
      vid1 = Factory.create(:video, :scene_id => scene.id, :user_id => user.id)
      vid2 = Factory.create(:video, :scene_id => scene.id, :user_id => user.id)
      vid1.upvote_by_user(user)

      scene.videos_by_score.count.should == 2
      scene.videos_by_score[0].should == vid1
      scene.videos_by_score[1].should == vid2
    end
  end

  describe '.by_date' do
    it 'returns list of scenes ordered by date' do
      project = Factory.create(:project)
      month3_scene = Factory.create(:scene, :project_id => project.id, :start_date => '2012/03/01')
      month1_scene = Factory.create(:scene, :project_id => project.id, :start_date => '2012/01/01')
      month2_scene = Factory.create(:scene, :project_id => project.id, :start_date => '2012/02/01')

      Scene.by_date[0].should == month1_scene
      Scene.by_date[1].should == month2_scene
      Scene.by_date[2].should == month3_scene
    end
  end

end
