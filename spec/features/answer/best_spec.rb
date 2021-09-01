require 'rails_helper'

feature 'User can choose the best answer of his question' do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:best_answer) { create(:answer, question: question, body: 'Best', best: true) }
  given(:user) { create(:user) }
  
  given!(:question_owner) { create(:question, user: user) }
  given!(:answer_owner) { create(:answer, question: question_owner, user: user) }
  given!(:reward) { create(:reward, question: question_owner) }

  describe 'Authenticated user tries to choose' do
    scenario 'The best answer of his question', js: true do
      sign_in(question.user)
      visit question_path(question)

      click_on 'Best answer'
      expect(page).to have_content "It's the best answer"
    end

    scenario "The best answer of someone else's question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end

    scenario 'another best answer of his question', js: true do
      sign_in(question.user)
      visit question_path(question)

      within "#answer-block-#{best_answer.id}.answer" do
        expect(page).to have_content "It's the best answer"
      end

      within "#answer-block-#{answer.id}.answer" do
        expect(page).to have_link 'Best answer'
        click_on 'Best answer'
      end

      within "#answer-block-#{best_answer.id}.answer" do
        expect(page).to have_link 'Best answer'
      end

      within "#answer-block-#{answer.id}.answer" do
        expect(page).to have_content "It's the best answer"
      end
    end

    scenario 'tries to see the list of the earned rewards', js: true do
      sign_in(question_owner.user)
      visit question_path(question_owner)
  
      # within "#answer-block-#{answer.id}" do
      click_on 'Best answer'
      # end
  
      visit rewards_path
  
      expect(page).to have_content 'New Reward'
    end
  end

  scenario 'View best answer first', js: true do
    sign_in(question.user)
    visit question_path(question)

    answers = page.all('.answer')

    expect(answers.first.native.attribute('id')).to eq "answer-block-#{best_answer.id}"

    click_on 'Best answer'

    expect(answers.first.native.attribute('id')).to eq "answer-block-#{answer.id + 1}"
  end

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end
