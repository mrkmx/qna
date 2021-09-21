class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    QuestionNotify.new.send_answer(answer)
  end
end
