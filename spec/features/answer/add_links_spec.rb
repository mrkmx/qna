require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:answer) { create(:answer) }
  given(:gist_url_1) {'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c'}
  given(:gist_url_2) {'https://gist.github.com/mrkmx/061390253c116c8509933b3b411e36d3'}

  scenario 'User adds links when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url_1

    click_on 'Add link'

    within all('.links-group').last do
      fill_in 'Link name', with: 'Second gist'
      fill_in 'Url', with: gist_url_2
    end

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url_1
      expect(page).to have_link 'Second gist', href: gist_url_2
    end
  end

  scenario 'User adds links when edits his answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    click_on 'Edit'

    within '.answers' do
      click_on 'Add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url_1

      click_on 'Add link'

      within all('.links-group').last do
        fill_in 'Link name', with: 'Second gist'
        fill_in 'Url', with: gist_url_2
      end

      click_on 'Save'

      expect(page).to have_link 'My gist', href: gist_url_1
      expect(page).to have_link 'Second gist', href: gist_url_2
    end
  end

end