require File.dirname(__FILE__) + '/../test_helper'

class BookTest < ActiveSupport::TestCase
  should_require_unique_attributes :isbn
  should_not_allow_values_for :isbn, "123", "9780596529322"
  should_allow_values_for :isbn, "9780596529321", "978-0-5965-2932-1", "0596529325", "0-596-52932-5"  
end
