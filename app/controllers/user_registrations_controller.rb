require 'strscan'
require 'command'
require 'bcrypt'

class UserRegistrationsController < ApplicationController
  def edit
    @user =  UserSession.find.user
  end

  def update
    password_orig = params[:password_orig]
    password = params[:password]
    password_conf = params[:password_conf]
    user_id = params[:user_id].to_i
    puts password
    puts password_conf
    puts user_id
    @user = User.find_by(id: user_id)
    if valid_admin_password?(password, password_conf) #&& @user.password == params[:password_orig] #not working
      Command.new("echo -e \"#{password}\n#{password}\" | passwd \"#{@user.login}\"")
      flash[:info] = "Login with your new Password"
      @user.update(password: password, password_confirmation: password_conf)
      redirect_to new_user_session_path
    else
      flash[:danger] = t 'not_a_valid_user_or_password'
      sleep 1
      render :action => 'edit'
      return
    end
  end
private

def valid_admin_password?(pwd, conf)
  return false if pwd.nil? or pwd.blank?
  return true if conf.size > 4 and pwd == conf
  false
end

end
