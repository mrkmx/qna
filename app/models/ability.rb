class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    return guest_abilities unless user.is_a?(User)
    return admin_abilities if user.admin?

    user_abilities(user)
  end

  private

  def guest_abilities
    can :read, :all
    can :create, Authorization
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities(user)
    can :read, :all

    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], { user_id: user.id }

    alias_action :vote, :revote, to: :vote_actions

    can :vote_actions, [Answer, Question] do |votable|
      votable.user_id != user.id
    end

    can :best, Answer do |resource|
      user.is_author?(resource.question)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      file.record.user_id == user.id
    end

    can :destroy, Link, linkable: { user_id: user.id }
  end
end
