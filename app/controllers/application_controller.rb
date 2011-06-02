class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_or_create_zooniverse_user

  def cas_logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
  helper_method :cas_logout
  
  def cas_login
    "#{CASClient::Frameworks::Rails::Filter.client.login_url}?service=http%3A%2F%2F#{ request.host_with_port }#{ request.fullpath }"
  end
  helper_method :cas_login
  
  def require_privileged_user
    unless current_zooniverse_user && current_zooniverse_user.privileged?
      flash[:notice] = t 'controllers.application.not_authorised'
      redirect_to root_url
      return false
    end
    
    true
  end
  
  protected
  def zooniverse_user
    session[:cas_user]
  end
  
  def zooniverse_user_id
    session[:cas_extra_attributes]['id']
  end
  
  def zooniverse_user_email
    session[:cas_extra_attributes]['email']
  end
  
  def zooniverse_user_public_name
    session[:cas_extra_attributes]['name']
  end
  
  def current_zooniverse_user
    @current_zooniverse_user ||= (ZooniverseUser.find_by_zooniverse_user_id(zooniverse_user_id) if zooniverse_user)
  end
  helper_method :current_zooniverse_user
  
  def check_or_create_zooniverse_user
    if zooniverse_user
      if user = ZooniverseUser.find_by_zooniverse_user_id(zooniverse_user_id)
        user.attributes.update(:name => zooniverse_user, :email => zooniverse_user_email, :public_name => zooniverse_user_public_name)
        user.save if user.changed?
      else
        ZooniverseUser.create(:zooniverse_user_id => zooniverse_user_id, :name => zooniverse_user, :email => zooniverse_user_email, :public_name => zooniverse_user_public_name)
      end
    end
  end
end
