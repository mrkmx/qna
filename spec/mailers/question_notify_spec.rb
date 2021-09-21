require 'rails_helper'

RSpec.describe QuestionNotifyMailer, type: :mailer do
  describe 'new_answer' do
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer)   { create(:answer, question: question, user: user) }
    let(:mail)     { QuestionNotifyMailer.new_answer(answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answer')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['test@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(question.body)
      expect(mail.body.encoded).to match(answer.user.email)
      expect(mail.body.encoded).to match(answer.title.truncate(15))
      expect(mail.body.encoded).to match(answer.title)
    end
  end
end
