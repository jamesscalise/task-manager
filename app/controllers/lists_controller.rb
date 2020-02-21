class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def index
    if logged_in?
      @lists = List.all
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
    if !logged_in?
      redirect_to root_path
    elsif !current_user.manager?
      redirect_to lists_path
    else
      @list = List.new
    end
  end

  def edit
    if !logged_in?
      redirect_to root_path
    elsif !current_user.manager?
      redirect_to list_path(@list)
    end
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to list_path(@list)
    else
      render :new
    end
    
  end

  def update
   
    if @list.update(list_params)
      redirect_to list_path(@list)
    else
      render :edit
    end
    
  end

  def destroy
    if current_user.manager?
      @list.destroy
    end
    redirect_to lists_path
  end

  private
   
    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:name)
    end
end
