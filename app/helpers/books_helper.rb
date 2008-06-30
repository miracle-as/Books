module BooksHelper
  def author_names(authors)
    authors.sort_by(&:name).collect { |a| link_to a.name, a }.to_sentence(:skip_last_comma => true, :connector => 'and'[:sentence_connector])
  end
  
  def days_ago(date)
    days = (Date.today - date.to_date)
    if days == 0
      'today'[:today]
    elsif days == 1
      '1 day ago'[:for_1_day_ago]
    else
      '{days} days ago'[:for_x_days_ago, days]
    end
  end
end
