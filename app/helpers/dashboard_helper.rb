module DashboardHelper
  def tag_link(tag, max_tag_count)
    link_to tag.name, books_path(:tag => tag.name), :style => "font-size: #{tag_size(tag, max_tag_count)}%"
  end
  
  protected
  def tag_size(tag, max_tag_count)
    (100 + ((tag.count - 1) * tag_scale(max_tag_count))).to_i
  end
  
  def tag_scale(max_tag_count)
    100 / (max_tag_count - 1)
  end
end
