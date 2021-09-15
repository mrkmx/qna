require 'rails_helper'

describe Ability, type: :model, aggregate_failures: true do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, :all }
    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :create, Authorization }    
  end

  describe 'for admin' do
    let(:user) { create(:user, :admin) }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let(:user_question) { create(:question, user: user) }
    let(:other_user_question) { create(:question, user: other_user) }

    let(:user_answer) { create(:answer, question: user_question, user: user) }
    let(:other_user_answer) { create(:answer, question: other_user_question, user: other_user) }
      
    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }
    it { is_expected.to be_able_to :me, User }

    context 'with questions' do
      it { is_expected.to be_able_to :create, Question }

      it { is_expected.to be_able_to :update, user_question }
      it { is_expected.not_to be_able_to :update, other_user_question }

      it { is_expected.to be_able_to :destroy, user_question }
      it { is_expected.not_to be_able_to :destroy, other_user_question }

      it { is_expected.to be_able_to :vote_actions, other_user_question }
      it { is_expected.not_to be_able_to :vote_actions, user_question }
    end

    context 'with answers' do
      it { is_expected.to be_able_to :create, Answer }

      it { is_expected.to be_able_to :update, user_answer }
      it { is_expected.not_to be_able_to :update, other_user_answer }

      it { is_expected.to be_able_to :destroy, user_answer }
      it { is_expected.not_to be_able_to :destroy, other_user_answer }

      it { is_expected.to be_able_to :vote_actions, other_user_answer }
      it { is_expected.not_to be_able_to :vote_actions, user_answer }

      it { is_expected.to be_able_to :best, user_answer }
      it { is_expected.not_to be_able_to :best, other_user_answer }
    end

    context 'with comments' do
      it { is_expected.to be_able_to :create, Comment }
    end

    context 'with links' do
      context 'when them belong to questions' do
        it { is_expected.to be_able_to :destroy, create(:link, linkable: user_question) }
        it { is_expected.not_to be_able_to :destroy, create(:link, linkable: other_user_question) }
      end

      context 'when them belong to answers' do
        it { is_expected.to be_able_to :destroy, create(:link, linkable: user_answer) }
        it { is_expected.not_to be_able_to :destroy, create(:link, linkable: other_user_answer) }
      end
    end

    
  end
end
