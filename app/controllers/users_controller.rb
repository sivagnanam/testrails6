class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show 
    @user = User.find(params[:id])
    @articles =@user.articles
  end

  def index
    @users = User.all 
      
  end
  def create
    #byebug
    @user = User.new(user_params)
    if @user.save
        flash[:notice] ="Welcome to Siva's Blog #{@user.username}, you've successfully signed up"
        redirect_to articles_path
    else
        render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update (user_params)
        flash[:notice] =" You've successfully updated your profile"
        redirect_to articles_path
    else
        render 'edit'
    end
  end

  private

  def user_params 
    params.require(:user).permit(:username,:email,:password)
  end

end
