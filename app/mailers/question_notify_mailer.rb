class QuestionNotifyMailer < ApplicationMailer
  def new_answer(user, answer)
    @answer = answer
    @question = answer.question
    @owner = answer.user

    mail to: user.email
  end
end
