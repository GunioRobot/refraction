class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= current_user ||=User.new
    if user.role? 'admin'
      can :manage, :all
    elsif user.role? 'editor'
      can :manage, Tweet
    else
      cannot :manage, :all
    end
    
    
    
    
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
