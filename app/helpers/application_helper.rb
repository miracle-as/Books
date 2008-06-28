# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(page_title)
    @page_title = page_title
  end

  def formatted_page_title
    'Books'[:application_name] + (@page_title.blank? ? '' : ' - ' + @page_title)
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end