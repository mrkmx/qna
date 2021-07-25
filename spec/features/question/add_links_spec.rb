require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url_1) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:gist_url_2) { 'https://gist.github.com/mrkmx/061390253c116c8509933b3b411e36d3' }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url_1

    click_on 'Add link'

    within all('.link-group').last do
      fill_in 'Link name', with: 'Second gist'
      fill_in 'Url', with: gist_url_2
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url_1
    expect(page).to have_link 'Second gist', href: gist_url_2
  end

end
