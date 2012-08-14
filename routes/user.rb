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
    user_id = session[:user]
    @user_opportunities = Opportunity.all(:user_id => user_id)
    @current_username = User.first(:id => user_id).username
    haml :user 
  end

  get "/signup" do
   haml :signup
  end

  post "/signup" do
    signup(params[:user])
  end

  def login
    if user = User.authenticate(params[:username], params[:password])
      session[:user] = user.id
      redirect_to_stored
    else
      redirect "/login"
    end
  end

  def logout
    session[:user] = nil
    redirect "/"
  end

  def signup(new_user)
     @new_user = UserService.create(new_user)
     if @new_user.valid?
       session[:user] = @new_user.id
       redirect "/user"
     else
       puts @new_user.errors.full_messages
       redirect "/signup"
    end
  end
end
