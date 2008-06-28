module BooksHelper
  def author_names(authors)
    authors.sort_by(&:name).collect { |a| link_to a.name, a }.to_sentence(:skip_last_comma => true)
  end
end
