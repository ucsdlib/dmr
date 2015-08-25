class Users::SessionsController < ApplicationController
  def new
    if Rails.configuration.shibboleth
      redirect_to shibboleth_path
    else
      redirect_to developer_path
    end
  end

  def developer
    find_or_create_user('developer')
  end
  
  def shibboleth
    find_or_create_user('shibboleth')
  end

  def find_or_create_user(auth_type)
    find_or_create_method = "find_or_create_for_#{auth_type.downcase}".to_sym
  	@user = User.send(find_or_create_method,request.env["omniauth.auth"])
  	create_user_session(@user) if @user
  	if Rails.configuration.shibboleth && !User.in_super_user_group?(@user.uid)
  	  render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
  	else
      redirect_to root_url, notice: "You have successfully authenticated from #{auth_type} account!"
    end
  end

  def destroy
    destroy_user_session
    flash[:alert] = ('You have been logged out of DMR. To logout of all Single Sign-On applications, close your browser').html_safe if Rails.configuration.shibboleth

    redirect_to root_url
  end

  protected :find_or_create_user
  
  private
  
  def create_user_session(user)
    session[:user_name] = user.name
    session[:user_id] = user.uid
  end

  def destroy_user_session
    session[:user_name] = nil
    session[:user_id] = nil
  end  

  
 end
