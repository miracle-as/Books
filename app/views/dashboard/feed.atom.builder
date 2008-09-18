atom_feed(:url => formatted_books_url(:atom)) do |feed|
  feed.title('Books')
  feed.updated(@books.first ? @books.first.created_at : Time.now.utc)

  @books.each do |book|
    feed.entry(book) do |entry|
      entry.title(book.name)
      entry.content('by'[] + ' ' + book.authors.collect(&:name).sort.to_sentence(:skip_last_comma => true, :connector => 'and'[:sentence_connector]))
    end
  end
end