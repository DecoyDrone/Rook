require_relative 'routes_helper'

class Rook < Sinatra::Base

  get "/login" do
    haml :login
  end

  post "/login" do
    login
  end

  get "/logout" do
    logout
  end

  get "/user" do
    login_required
    haml :user, :locals => { :user => current_user }
  end

  post "/profile/update.:id" do |id|
    params[:user_profile]["skills_desired"] = params[:user_profile].delete("skills_desired").split(/,\s*/)
    params[:user_profile]["skills_acquired"] = params[:user_profile].delete("skills_acquired").split(/,\s*/)
    @user_update = UserService.update(id, params[:user_profile])
    if @user_update.valid?
      flash[:info] = "Profile Updated"
      redirect "/user"
    else
      flash[:fatal] = @user_update.errors.full_messages.join(", ")
      redirect "/profile/update.#{id}"
    end
  end

  get "/signup" do
    #temp code for beta
    redirect "/beta"
    #haml :signup
  end

  get '/beta' do
    haml :beta
  end

  post "/signup" do
    signup(params[:user])
  end

  post "/beta_signup" do
    beta_signup(params[:user])
  end

  get '/beta_welcome' do
    haml :beta_welcome
  end

  def login
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user] = user.id
      flash[:info] = "Logged in"
      redirect_to_stored
    elsif 5 == session[:login_attempts]
      #future reset page
      redirect "/"
    else
      session[:login_attempts] = session[:login_attempts].to_i + 1
      flash[:fatal] = "Incorrect user or password"
      redirect "/login"
    end
  end

  def logout
    session[:user] = nil
    flash[:info] = "Logged out"
    redirect "/"
  end

  def signup(new_user)
     @new_user = UserService.create(new_user)
     if @new_user.valid?
       session[:user] = @new_user.id
       flash[:info] = 'Thanks for signing up!'
       redirect "/user"
     else
       flash[:fatal] = @new_user.errors.full_messages.join(", ")
       redirect "/signup"
    end
  end

  def beta_signup(new_user)
    @new_user = UserService.create(new_user)
    if @new_user.valid?
      flash[:info] = 'Signed up!'
      redirect "/beta_welcome"
    else
      flash[:fatal] = @new_user.errors.full_messages.join(", ")
      redirect "/beta"
    end
  end
end
