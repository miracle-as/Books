class SessionController < ApplicationController
  def destroy
    reset_session
    redirect_to(CASClient::Frameworks::Rails::Filter.client.logout_url(request.referer)) and return
  end
end