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

  describe "not from youtube or vimeo" do
    it 'errors and is not valid' do
      vid = Factory.build(:video, video_url:"http://www.you.com")
      #vid2 = Factory.build(:video, video_url:"http://www.youtube.com")
      expect {
        vid.save!
      }.to raise_error
      vid.valid?.should == false
    end
  end

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

  describe "validate vimeo.com links" do
    context 'valid video_id' do
      it 'gets valid video_id created' do
        vid = Factory.build(:video, video_url:"http://www.vimeo.com/31709533")
        vid.stub(:get_vimeo_thumbnail_url).and_return(vimeo_thumbnail_url)
        vid.save!
        vid.video_id.should == "31709533"
      end
    end

    context 'valid video_id in a group url' do
      it 'gets valid video_id created' do
        vid = Factory.build(:video, video_url:"http://vimeo.com/groups/01fx/videos/28546884")
        vid.stub(:get_vimeo_thumbnail_url).and_return(vimeo_thumbnail_url)
        vid.save!
        vid.video_id.should == "28546884"
      end
    end
  end

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

  describe "from unsupported site" do
    it 'fails validation' do
      vid = Factory.build(:video, video_url:"http://www.youwrong.com/watch?v=dQLCO9JkVeE")

      expect {
        vid.save!
      }.to raise_error
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

end
