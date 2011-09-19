class ApplicationController < ActionController::Base
  protect_from_forgery
  
  attr_accessor :current_zooniverse_user

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
  
  def zooniverse_user
     session[:cas_user]
   end
   helper_method :zooniverse_user

   def zooniverse_user_id
     session[:cas_extra_attributes]['id']
   end
   helper_method :zooniverse_user_id

   def zooniverse_user_api_key
     session[:cas_extra_attributes]['api_key']
   end
   helper_method :zooniverse_user_api_key

   def current_zooniverse_user
     @current_zooniverse_user ||= (ZooniverseUser.find_by_zooniverse_user_id(zooniverse_user_id) if zooniverse_user)
   end
   helper_method :current_zooniverse_user

   def ensure_current_user
     forbidden unless current_zooniverse_user && current_zooniverse_user.id.to_s == params[:user_id].to_s
   end

   def require_admin_user
     redirect_to root_url unless current_zooniverse_user && current_zooniverse_user.is_admin?
   end

   def require_api_user
     authenticate_or_request_with_http_basic do |username, password|
       SiteConfig.api_username == username && SiteConfig.api_password == password
     end
   end

   def check_or_create_zooniverse_user
     if zooniverse_user
       z = ZooniverseUser.find_or_create_by_zooniverse_user_id(zooniverse_user_id)
       z.update_attributes(:name => zooniverse_user, :api_key => zooniverse_user_api_key) if z.changed?
     end
   end
end
