#
# @author Vivian <tchu@ucsd.edu>
#
class Users::SessionsController < ApplicationController
  def new
    if Rails.configuration.shibboleth
      redirect_to shibboleth_path(origin: params[:origin])
    else
      redirect_to developer_path(origin: params[:origin])
    end
  end

  def developer
    find_or_create_user('developer', params[:origin])
  end

  def shibboleth
    find_or_create_user('shibboleth', params[:origin])
  end

  def find_or_create_user(auth_type, origin)
    @user = lookup_user(auth_type)
    if Rails.configuration.shibboleth && !User.in_group?(request.env['omniauth.auth'].uid) && report_url(origin) == false
      render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
    else
      create_user_session(@user) if @user
      redirect_to origin || root_url, notice: "Successfully authenticated from #{auth_type} account"
    end
  end

  def destroy
    destroy_user_session
    if Rails.configuration.shibboleth
      flash[:alert] = 'DMR Logged out. To logout of all Single Sign-On applications, close browser'
    end
    redirect_to root_url
  end

  protected :find_or_create_user

  private

  def create_user_session(user)
    session[:user_name] = user.name
    session[:user_id] = user.uid
    session[:student_user] = 'true'
  end

  def destroy_user_session
    session[:user_name] = nil
    session[:user_id] = nil
  end

  def report_url(original_url)
    quarters = %w[Spring Summer Fall Winter]
    quarters.each do |quarter|
      return true if original_url.include?(quarter)
    end
    false
  end

  def lookup_user(auth_type)
    find_or_create_method = "find_or_create_for_#{auth_type.downcase}".to_sym
    User.send(find_or_create_method, request.env['omniauth.auth'])
  end
end
