require 'rails_helper'

feature 'User can delete question' do
  given(:question) { create(:question) }

  describe 'Authenticated user tries to delete question' do
    scenario 'his question' do
      sign_in(question.user)
      visit question_path(question)
      expect(page).to have_content 'Question String'
      click_on 'Delete question'
      expect(page).to have_content 'Your question was succesfully deleted'
      expect(page).to_not have_content 'Question String'
    end

    scenario 'delete question with attached files', js: true do
      sign_in(question.user)
      visit question_path(question)
      within '.question' do
        click_on 'Edit question'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
  
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      within "#file_#{question.files.first.id}" do
        click_on 'Delete file'
      end
  
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario "someone else's question" do
      user = create(:user)

      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
