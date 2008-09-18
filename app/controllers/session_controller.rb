class SessionController < ApplicationController
  def destroy
    session.delete
    redirect_to(CASClient::Frameworks::Rails::Filter.client.logout_url(request.referer)) and return
  end
end