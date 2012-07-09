require 'spec_helper'

describe Video do
  let(:vimeo_thumbnail_url) { "http://b.vimeocdn.com/ts/302/062/302062320_640.jpg" }
  before(:each) do
    [User, Video].each { |item| item.destroy_all }
  end

  after(:each) do
    [User, Video].each { |item| item.destroy_all }
  end

# TODO cases to take care of in the future
#invalid http://vimeo.com/3170953

  describe ".new" do
    context "from vimeo.com" do
      context "url is http://player.vimeo.com/video/43119058" do
        let(:video) { Factory.build(:video, video_url:"http://player.vimeo.com/video/43119058") }

        before(:each) do
          video.stub(:get_vimeo_thumbnail_url).and_return(vimeo_thumbnail_url)
        end

        it "acceptable url" do
          expect do
            video.save!
          end.to_not raise_error
        end

        it "creates valid video record" do
          video.save!
          video.video_id.should == "43119058"
        end

        it "creates thumbnail link", r:true do
          # thumbnail only created when saved
          video.save!

          expect do
            thumb = URI.parse(video.thumbnail_url)
          end.to_not raise_error
        end
      end
    end
  end

  context "vimeo.com" do
    context 'url is www.vimeo.com' do
      it 'valid video_id created' do
        vid = Factory.build(:video, video_url:"http://www.vimeo.com/31709533")
        vid.stub(:get_vimeo_thumbnail_url).and_return(vimeo_thumbnail_url)
        vid.save!
        vid.video_id.should == "31709533"
      end
    end

    context 'url is vimeo.com/groups/...' do
      it 'valid video_id created' do
        vid = Factory.build(:video, video_url:"http://vimeo.com/groups/01fx/videos/28546884")
        vid.stub(:get_vimeo_thumbnail_url).and_return(vimeo_thumbnail_url)
        vid.save!
        vid.video_id.should == "28546884"
      end
    end
  end

  context "youtube.com" do
    describe "from youtube.com" do
      context 'valid video_id in url' do
        it 'gets valid video_id created' do
          vid = Factory.create(:video, video_url:"http://www.youtube.com/watch?v=dQLCO9JkVeE")
          vid.video_id.should == "dQLCO9JkVeE"
        end
      end

      context "missing video_id in url (eg. from a user's channel)" do
        it 'fails validation' do
          vid = Factory.build(:video, video_url:"http://www.youtube.com/user/BlueXephos?feature=watch")

          expect {
            vid.save!
          }.to raise_error
        end
      end
    end

    describe "from youtu.be" do
      context 'with valid video_ID (right length == valid)' do
        it 'gets valid video_id created' do
          vid = Factory.build(:video, video_url:"http://www.youtu.be/dQLCO9JkVeE")
          vid.save!

          vid.video_id.should == "dQLCO9JkVeE"
        end
      end

      context 'with invalid video_ID (invalid meaning length < 11)' do
        it 'fails validation' do
          vid = Factory.build(:video, video_url:"http://www.youtu.be/dQCO9JkVeE")
          expect {
            vid.save!
          }.to raise_error
        end
      end
    end
  end

  describe "not from youtube or vimeo" do
    it 'errors and is not valid' do
      vid = Factory.build(:video, video_url:"http://www.you.com")
      expect {
        vid.save!
      }.to raise_error
      vid.valid?.should == false
    end
  end

  context "logged in user" do
    describe ".upvote_by_user(user)" do
      it "saves score to database" do
        user = Factory.build(:user)
        video = Factory.create(:video)
        video.upvote_by_user(user)

        Video.find(video.id).score.should == video.score
      end
    end

    describe ".downvote_by_user(user)" do
      it "saves score to database" do
        user = Factory.build(:user)
        video = Factory.create(:video)
        video.downvote_by_user(user)

        Video.find(video.id).score.should == video.score
      end
    end
  end

  describe ".with_scene_id" do
    it 'only gets videos for specified scene' do
      scene = Factory.create(:scene)
      other_scene = Factory.create(:scene)
      video = Factory.create(:video, :scene_id => scene.id)
      other_video = Factory.create(:video, :scene_id => other_scene.id)

      Video.with_scene_id(scene.id).include?(other_video).should == false
    end
  end

  describe ".comment_threads_by_date" do
    it 'orders comments by newest first' do
      # 2 users needed otherwise spam protection will kick in
      user1 = Factory.create(:user)
      user2 = Factory.create(:user)
      video = Factory.create(:video)
      comment1 = Comment.build_from(video, user1.id, "comment1")
      comment1.save
      comment2 = Comment.build_from(video, user2.id, "comment2")
      comment2.save

      comments = video.comment_threads_by_date

      comments[0].should == comment2
      comments[1].should == comment1
    end
  end

  describe ".from_youtube" do
    it 'true for videos from youtube.com' do
      url = "http://www.youtube.com"
      v = Factory.build(:video, :video_url => url)
      v.from_youtube.should == true
    end

    it 'true for videos from youtu.be' do
      url = "http://www.youtu.be"
      v = Factory.build(:video, :video_url => url)
      v.from_youtube.should == true
    end
  end

  describe ".from_vimeo" do
    it 'true for videos from vimeo urls' do
      url = "http://vimeo.com"
      v = Factory.build(:video, :video_url => url)
      v.from_vimeo.should == true
    end
    
  end
end
