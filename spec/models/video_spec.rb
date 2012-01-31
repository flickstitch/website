require 'spec_helper'

describe Video do

  describe "from youtube.com" do
    context 'valid video_id in url' do
      it 'gets valid video_id created' do
        vid = Video.new :video_url => "http://www.youtube.com/watch?v=dQLCO9JkVeE"
        vid.save!

        vid.video_id.should == "dQLCO9JkVeE"
      end
    end

    context "missing video_id in url (eg. from a user's channel)" do
      it 'fails validation' do
        vid = Video.new :video_url => "http://www.youtube.com/user/BlueXephos?feature=watch"

        expect {
          vid.save!
        }.to raise_error
      end
    end
  end

  describe "from youtu.be" do
    context 'with valid video_ID (right length == valid)' do
      it 'gets valid video_id created' do
        vid = Video.new :video_url => "http://www.youtu.be/dQLCO9JkVeE"
        vid.save!

        vid.video_id.should == "dQLCO9JkVeE"
      end
    end

    context 'with invalid video_ID (invalid meaning length < 11)' do
      it 'fails validation' do
        vid = Video.new :video_url => "http://www.youtu.be/dQCO9JkVeE"
        expect {
          vid.save!
        }.to raise_error
      end
    end
  end

  describe "from unsupported site" do
    it 'fails validation' do
      vid = Video.new :video_url => "http://www.youwrong.com/watch?v=dQLCO9JkVeE"

      expect {
        vid.save!
      }.to raise_error
    end
  end

end
