class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :rewards, dependent: :nullify
  has_many :votes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def is_author?(resource)
    self.id == resource.user_id
  end

  def voted?(resource)
    votes.where(votable: resource).present?
  end
  
end
