require 'rails_helper'

feature 'The user can add a reward to the question', %q{
  In order to reward the author of the best answer
  As an author of the question
  I would like to be able to set a reward
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds a reward when asks a question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test question body'

    within '.reward-group' do
      fill_in 'Reward', with: 'My Reward'
      attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Ask'

    expect(page).to have_content 'Test question'
    expect(user.reload.questions.last.reward.persisted?).to be_truthy
  end
end
