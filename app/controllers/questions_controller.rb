class QuestionsController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy comment]

  after_action :publish_question, only: %i[create destroy]

  authorize_resource except: :comment
  skip_authorization_check only: :comment

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @subscription = @question.subscriptions.find_by(user: current_user)
  end

  def new
    @question = Question.new
    @question.links.build
    @question.reward = Reward.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question was succesfully deleted'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:title, :image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.renderer.render(
        partial: 'questions/question',
        locals: {
          question: @question,
          current_user: current_user
        }
      )
    )
  end
end
