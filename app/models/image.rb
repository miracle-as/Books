class Image < ActiveRecord::Base
  def image_tag
    "<img src='#{self.url}' width='#{self.width}' height='#{self.height}' />"
  end
end
