ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


def cas_login(request)
  "#{CASClient::Frameworks::Rails::Filter.client.login_url}?service=http%3A%2F%2F#{ request.host_with_port }#{ request.fullpath }"
end

module Shoulda
  module Context
    class Context
      def should_have_keys(*keys)
        klass = described_type
        
        keys.each do |key|
          should "have key #{key}" do
            assert_contains klass.fields.keys, key.to_s, "#{klass.name} does not have key #{key}"
          end
        end
      end
      
      def should_associate(*klasses)
        # TODO figure out how Mongoid deals with this
        # klass = described_type
#         
        # klasses.each do |other_klass|
          # should "have associated #{other_klass}" do
            # assert_contains klass.associations.keys, other_klass.to_s
          # end
        # end
      end
      
      def should_include_modules(*modules)
        _should_include(*modules) do |klass, mod|
          should "include module #{mod}" do
            assert klass.include?(mod), "#{klass.name} does not include module #{mod}"
          end
        end
      end
      
      def should_include_plugins(*plugins)
        _should_include(*plugins) do |klass, plugin|
          should "include plugin #{plugin}" do
            assert klass.plugins.include?(plugin), "#{klass.name} does not include plugin #{plugin}"
          end
        end
      end
      
      private
      def _should_include(*args, &block)
        klass = described_type
        
        args.each do |arg|
          arg = arg.to_s.camelize.constantize
          yield(klass, arg)
        end
      end
    end
  end
end


class ActiveSupport::TestCase
  
  def teardown
    Mongoid.database.collections.each do |coll|
      coll.remove  unless coll.name =~ /(.*\.)?system\..*/
    end
  end

  # Make sure that each test case has a teardown
  # method to clear the db after each test.
  def inherited(base)
    base.define_method teardown do
      super
    end
  end
  
  def standard_cas_login(user = nil)
    @user = user ||= FactoryGirl.create(:zooniverse_user)
    @request.session[:cas_user] = @user.name
    @request.session[:cas_extra_attributes] = {}
    @request.session[:cas_extra_attributes]['id'] = @user.zooniverse_user_id
    CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(true)
    CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(true)
  end
  
  def standard_cas_login_without_stub(user = nil)
    @user = user ||= FactoryGirl.create(:zooniverse_user)
    @request.session[:cas_user] = @user.name
    @request.session[:cas_extra_attributes] = {}
    @request.session[:cas_extra_attributes]['id'] = @user.zooniverse_user_id
  end
  
  def admin_cas_login
    @user = FactoryGirl.create :zooniverse_user, :admin => true
    standard_cas_login(@user)
  end
  
  def clear_cas
    @user = FactoryGirl.create :zooniverse_user
    @request.session[:cas_user] = {}
    @request.session[:cas_extra_attributes] = {}
  end
end
