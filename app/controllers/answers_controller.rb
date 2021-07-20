class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[show edit update destroy]
  before_action :check_author, only: %i[update destroy]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'The answer was succesfully created'
    else
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render 'questions/show', notice: 'The answer was succesfully updated'
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question, notice: 'The answer succesfully deleted'
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def check_author
    redirect_to @answer.question, notice: 'You are not the author' unless current_user.is_author?(@answer)
  end
end
