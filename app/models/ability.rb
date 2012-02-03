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

      case
        when user.has_role?(:admin)
          can :manage, :all
        when user.has_role?(:manager)
        else
      end
    end
  end

end
