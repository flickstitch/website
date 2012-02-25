require 'spec_helper'

describe Comment do
  
  describe "submit comments" do
    it 'allowed once every minute' do
      vid = Factory.create(:video)
      user = Factory.create(:user)
      now_time = ''

      comment = Comment.build_from(vid, user.id, "first comment")
      comment.created_at = DateTime.now - 1.minute
      comment.save!

      comment2 = Comment.build_from(vid, user.id, "second comment")
      comment2.save!
    end

    it 'disallow submitting again before 30 seconds is up' do
      vid = Factory.create(:video)
      user = Factory.create(:user)
      now_time = ''

      comment = Comment.build_from(vid, user.id, "first comment")
      comment.created_at = DateTime.now - 29.seconds
      comment.save!

      comment2 = Comment.build_from(vid, user.id, "second comment")
      expect do
        comment2.save!
      end.to raise_error ActiveRecord::RecordInvalid, /must wait/
    end
  end

end
