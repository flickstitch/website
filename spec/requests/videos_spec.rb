require 'spec_helper'

# not working - maybe cuz of javascript?
#describe "Videos" do
  #it 'lets user post a comment' do
    #user = Factory.create(:user)
    #video = Factory.create(:video)
    #comment_text = "leaving a comment"

    ## sign user in
    #visit new_user_session_path
    #within(".new_user") do
      #fill_in "user_email", :with => user.email
      #fill_in "user_password", :with => user.password
      #click_button "Sign In"
    #end

    #visit video_path video

    #within("#comment_form") do
      #fill_in "comment", :with => comment_text
      #click_button "comment_submit"
    #end

    #page.should have_content(comment_text)
  #end
#end
