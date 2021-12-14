class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  def new
    @user = User.new
  end

  def edit
    
  end

  def show 
    
    #@articles =@user.articles
    @articles = @user.articles.paginate(page: params[:page], per_page: 2)
  end

  def index
    #@users = User.all 
    @users = User.paginate(page: params[:page], per_page: 2)
  end
  def create
    #byebug
    @user = User.new(user_params)
    if @user.save
        session[:user_id] = @user.id 
        flash[:notice] ="Welcome to Siva's Blog #{@user.username}, you've successfully signed up"
        redirect_to articles_path
    else
        render 'new'
    end
  end

  def update
    
    if @user.update (user_params)
        flash[:notice] =" You've successfully updated your profile"
        redirect_to @user
    else
        render 'edit'
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user
    flash[:notice] = "Account and all associated articles are deleted"
    redirect_to articles_path
  end

  private

  def user_params 
    params.require(:user).permit(:username,:email,:password)
  end

  def set_user 
    @user = User.find(params[:id])
  end

  def require_same_user 
    if current_user!=@user && !current_user.admin?
        flash[:alert] = "you can only edit or delete your profile"
        redirect_to @user
    end
  end
end
