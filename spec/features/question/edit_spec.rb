require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user tries to edit' do
    scenario 'his question', js: true do
      sign_in(question.user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited title'
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited body'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'his question with errors', js: true do
      sign_in(question.user)
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
      end

      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
