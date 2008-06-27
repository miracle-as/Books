# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(page_title, options = {})
    @page_title = page_title
    @page_title_options = options
  end
  
  def page_title
    title = 'Books'[]
    title << ': ' + @page_title unless @page_title.blank?
    title
  end
end