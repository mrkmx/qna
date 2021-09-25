class SearchesController < ApplicationController
  skip_authorization_check

  def index
    @search_results = QuerySearch.new.call(search: Search.new(search_params))
  end

  private

  def search_params
    params.require(:search).permit(:query, :scope)
  end
end