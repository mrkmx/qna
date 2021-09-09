class AnswersController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, except: %i[show]
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[show edit update destroy best]

  after_action :publish_answer, only: :create

  authorize_resource except: :comment
  skip_authorization_check only: :comment

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def best
    @question = @answer.question
    @answer.mark_as_best
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@question.id}",
      answer: @answer,
      rating: @answer.rating,
      links: @answer.links
    )
  end
  
end
