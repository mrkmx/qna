class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comment_#{data['question_id']}"
  end
end