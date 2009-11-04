module Kernel
  def singleton_class
    class << self; self; end
  end
end

module CasTestHelper

  def login_as(user)
    user = users(user)
    CASClient::Frameworks::Rails::Filter.singleton_class.class_eval do
     alias :original_filter :filter
    end
    # Stub the filter method
    CASClient::Frameworks::Rails::Filter.singleton_class.send :define_method, :filter do |controller|
      controller.session[:casfilteruser] = user.login
      controller.session[:cas_extra_attributes] = {}
      true
    end
  
    return user
  end
  
  def reset_cas
    unstub_cas
  
    CASClient::Frameworks::Rails::Filter.singleton_class.send :define_method, :filter do |controller|
      CASClient::Frameworks::Rails::Filter.redirect_to_cas_for_authentication(controller)
      false
    end
  end
  
  def unstub_cas
    CASClient::Frameworks::Rails::Filter.singleton_class.class_eval do
       if self.respond_to?(:original_filter)
         alias :filter :original_filter
         undef :original_filter
       end
     end
  end

end
