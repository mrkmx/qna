class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[show edit update destroy best]
  before_action :check_author, only: %i[update destroy]
  before_action :check_question_author, only: %i[best]

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
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def check_author
    redirect_to @answer.question, notice: 'Only author can do it' unless current_user.is_author?(@answer)
  end

  def check_question_author
    @question = @answer.question
    redirect_to @question, notice: 'Only author can do it' unless current_user.is_author?(@question)
  end
end
