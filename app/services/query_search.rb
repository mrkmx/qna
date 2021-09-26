class QuerySearch
  SEARCH_SCOPES = %w[Question Answer Comment User].freeze

  def call(search:)
    ThinkingSphinx.search(
      ThinkingSphinx::Query.escape(search.query),
      classes: [search_klass(search.scope)]
    ).to_a
  end

  private

  def search_klass(scope)
    return unless SEARCH_SCOPES.include?(scope)

    scope.classify.constantize
  end
end
