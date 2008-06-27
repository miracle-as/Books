# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(page_title)
    @page_title = page_title
  end
  
  def formatted_page_title
    'Books' + (@page_title.blank? ? '' : ' - ' + @page_title)
  end
end