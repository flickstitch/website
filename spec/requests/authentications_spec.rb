require 'spec_helper'

feature "Sign up new user" do
  let(:user) { Factory.build(:user) }

  scenario "with valid username" do
    visit new_user_registration_path

    fill_in "user_username", :with => user.username
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    fill_in "user_password_confirmation", :with => user.password

    click_button 'sign_up'

    within ".flash-notice" do
      page.should have_content "signed up successfully"
    end
  end

  scenario "with invalid username" do
    visit new_user_registration_path

    # only alphanumeric allowed in username
    fill_in "user_username", :with => 'aaa<3a'
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    fill_in "user_password_confirmation", :with => user.password

    click_button 'sign_up'

    within "#error_explanation" do
      page.should have_content "Username must be"
    end
  end

end

feature "login" do
  let(:user) { Factory.create(:user) }

  scenario "with valid username/password" do
    visit new_user_session_path

    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password

    click_button "sign_in"

    within ".flash-notice" do
      page.should have_content "Signed in successfully"
    end

    # show username
    page.should have_content user.username
    page.should_not have_content user.email
  end

  scenario "with invalid password" do
    visit new_user_session_path

    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password + 'wrong_password'

    click_button "sign_in"

    within ".flash-alert" do
      page.should have_content "Invalid email or password"
    end
  end

end
