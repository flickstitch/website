module UsersHelper
  def simple_user_link(user)
    link_to user.username, user_path(user.id)
  end
end
