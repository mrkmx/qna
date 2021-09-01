require 'rails_helper'

feature 'The user can leave a comment for the question or the answer', %q{
  In order to share self opinion
  As an authenticated user
  I'd like to write a comment for the question ot the answer
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    describe 'tries to leave a comment for the question' do
      scenario 'with valid data' do
        within '.comments__question' do
          fill_in 'Your comment', with: 'Question comment'
          click_on 'Create comment'

          expect(page).to have_content 'Question comment'
        end
      end

      scenario 'with invalid data' do
        within '.comments__question' do
          click_on 'Create comment'

          expect(page).to have_content "Body can't be blank"
        end
      end
    end

    describe 'tries to leave a comment for the answer' do
      scenario 'with valid data' do
        within "#answer-block-#{answer.id}" do
          fill_in 'Your comment', with: 'Answer comment'
          click_on 'Create comment'

          expect(page).to have_content 'Answer comment'
        end
      end

      scenario 'with invalid data' do
        within "#answer-block-#{answer.id}" do
          click_on 'Create comment'

          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end

  describe 'Multiple sessions' do
    scenario 'with the comment appears on another page of the user' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.comments__question' do
          fill_in 'Your comment', with: 'Broadcast question comment'
          click_on 'Create comment'
        end

        within "#answer-block-#{answer.id}" do
          fill_in 'Your comment', with: 'Broadcast answer comment'
          click_on 'Create comment'
        end

        expect(page).to have_content 'Broadcast question comment'
        expect(page).to have_content 'Broadcast answer comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Broadcast question comment'
        expect(page).to have_content 'Broadcast answer comment'
      end
    end
  end

  scenario 'Unauthenticated user tries to leave a comment for the resource' do
    visit question_path(question)

    expect(page).to_not have_selector '.new-comment'
  end
end
