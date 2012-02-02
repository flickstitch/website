class Ability
  include CanCan::Ability

  def initialize(user)
    # guest/anon user - not logged in
    if user.nil?
      can :read, Video
      cannot [:new, :edit], Video
    else
      # regular user
      can [:create, :read], Video
      can :manage, Video do |v|
        v.user == user
      end
    end
  end

end
