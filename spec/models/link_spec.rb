require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { is_expected.to allow_values('http://example.com', 'https://example.com', 'ftp://example.com').for(:url) }
  it { is_expected.to_not allow_values('example.com', 'example').for(:url) }

end
