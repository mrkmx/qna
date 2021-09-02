require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to :user }

  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  describe 'the uniqueness of the :uid scoped to :provider' do
    before do
      user = create(:user)

      create(:authorization, user: user)
    end

    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider).case_insensitive }
  end
end