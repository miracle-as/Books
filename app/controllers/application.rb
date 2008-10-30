# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include HoptoadNotifier::Catcher

  helper :all # include all helpers, all the time
  protect_from_forgery # :secret => 'c7f33ae0010ebe3668f420c07e12792b'

  before_filter CASClient::Frameworks::Rails::Filter, :except => :feed
  before_filter :initialize_empty_search
  around_filter :set_language

  def current_user
    return nil unless session[:casfilteruser]
    @current_user ||= find_or_create_user(session[:casfilteruser], session[:cas_extra_attributes])
  end
  helper_method :current_user
  
  protected
  def find_or_create_user(login, extra_attributes)
    user = User.find_or_create_by_login(login)
    
    common_name = extra_attributes['cn']
    user.update_attribute :name, common_name if common_name && user.name != common_name
    
    user
  end

  def initialize_empty_search
    @search = Search.new
  end
  
  def set_language
    Gibberish.use_language('da') { yield }
  end
end
