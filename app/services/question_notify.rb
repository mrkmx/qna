class QuestionNotify
  def send_answer(answer)
    answer.question.subscribers.find_each do |user|
      QuestionNotifyMailer.new_answer(user, answer)&.deliver_later unless user.is_author?(answer)
    end
  end
end
