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

  def tag_link(tag, max_tag_count)
    link_to tag.name, books_path(:tag => tag.name), :style => "font-size: #{tag_size(tag, max_tag_count)}%"
  end
  
  def tag_links(tag)
    tag.collect { |t| tag_link t, 1 }.join(', ')
  end
  
  protected
  def tag_size(tag, max_tag_count)
    return 100 unless max_tag_count > 1
    (100 + ((tag.count - 1) * tag_scale(max_tag_count))).to_i
  end
  
  def tag_scale(max_tag_count)
    100 / (max_tag_count - 1)
  end
end
