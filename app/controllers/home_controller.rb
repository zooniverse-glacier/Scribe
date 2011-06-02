class HomeController < ApplicationController
  before_filter CASClient::Frameworks::Rails::GatewayFilter
  
  def index
    
  end
end
