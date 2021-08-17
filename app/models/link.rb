class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  
  validates :name, :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https ftp]), message: "It's not a valid URL" }
end
