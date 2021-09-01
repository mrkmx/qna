class Comment < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :commentable, touch: true, polymorphic: true

  validates :body, presence: true
end
