class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  
  def index
    if logged_in?
      @users = User.all
    else
      redirect_to root_path
    end
  end

  def show
    if !logged_in?
      redirect_to root_path
    end
  end

  def new
    if logged_in?
      redirect_to user_path(current_user)
    end
    @user = User.new
  end

  def edit
    if !logged_in?
      redirect_to root_path
    elsif !current_user.manager?
      redirect_to user_path(@user)
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def update
    @user.update(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

 
  def destroy
    if current_user.manager?
      @user.destroy
    else
      redirect_to user_path(@user)
    end
    
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password, :manager)
    end
end
