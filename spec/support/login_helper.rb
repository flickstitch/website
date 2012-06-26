module LoginHelper
  def login_user(user)
    visit new_user_session_path

    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password

    click_button "sign_in"
  end
end
