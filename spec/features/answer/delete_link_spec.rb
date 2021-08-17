require 'rails_helper'

feature 'User can delete links from his answer' do
  given(:answer) { create(:answer, :with_link) }

  scenario 'User deletes links when edits his answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    expect(page).to have_link 'My gist', href: 'https://gist.github.com/mrkmx/061390253c116c8509933b3b411e36d3'

    within '.answers' do
      click_on 'Edit'
      click_on 'Delete link'
      click_on 'Save'
    end

    expect(page).to_not have_link 'My gist', href: 'https://gist.github.com/mrkmx/061390253c116c8509933b3b411e36d3'
  end
end