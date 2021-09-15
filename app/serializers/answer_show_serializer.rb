class AnswerShowSerializer < ActiveModel::Serializer
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
end
