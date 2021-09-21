class Question < ApplicationRecord
  include Votable
  include Commentable
  
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :user
  
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create { subscribe(user) }

  scope :per_day, -> { where(created_at: Date.today.all_day) }

  def subscribe(user)
    subscriptions.create!(user: user) unless subscribed?(user)
  end

  def unsubscribe(user)
    subscriptions.find_by(user: user).destroy if subscribed?(user)
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end
end
