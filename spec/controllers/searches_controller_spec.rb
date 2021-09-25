require 'rails_helper'

describe SearchesController, type: :controller, aggregate_failures: true do
  describe 'GET #index' do
    context 'when the query is provided' do
      let(:question) { create(:question) }

      let(:search_params) do
        { query: 'QuestionTitle', scope: 'Question' }
      end

      before do
        allow(ThinkingSphinx).to receive(:search).with(search_params[:query], classes: [search_params[:scope].classify.constantize]).and_return([question])
      end

      it 'renders index template' do
        get :index, params: { search: search_params }

        expect(response).to render_template :index
      end

      it 'assigns @search_results variable' do
        get :index, params: { search: search_params }

        expect(assigns(:search_results)).to be_an(Array)
      end
    end

  end
end
