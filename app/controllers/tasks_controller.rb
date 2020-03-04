require 'pry'

class TasksController < ApplicationController
  before_action :find_user, :find_list
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete]
  
  def search
    @tasks = Task.
    render :index
  end
  
  def index
    if logged_in?
      if @user
        @tasks = @user.tasks.all
      elsif @list
        @tasks = @list.tasks.all
      else
        @tasks = Task.all
      end
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
      redirect_to user_path(current_user)
    elsif @list
      @task = @list.tasks.build
      
    elsif @user
      @task = @user.tasks.build
    else
      @task = Task.new
    end
  end

  def edit
    if !logged_in?
      redirect_to root_path
    elsif !current_user.manager?
      redirect_to task_path(@task)
    end
  end

  def create
   # if @user
     # @task = @user.tasks.create(task_params)
   # elsif @list
   #   @task = @list.tasks.create(task_params)
   # else
      @task = Task.new(task_params)
   # end
    
   if @task.save
      redirect_to task_path(@task)
    else
      render :new
    end
   
  end

  def update
      if @task.update(task_params)
        redirect_to task_path(@task)
      else
        render :edit
      end
  end

  def destroy
    if current_user.manager?
      @task.destroy
    end
    redirect_to tasks_path
  end

  def complete
    
    if (@task.user == current_user) || current_user.manager?
      @task.completed = true
      @task.save
    else
      flash[:notice] = "You are not eligible to mark this as complete"
    end
    
    redirect_to task_path(@task)
  end

  def next_ten_due
    @tasks = Task.next_ten_due
    render :index
  end

  def incomplete_tasks
    @tasks = Task.incomplete_tasks
    render :index
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:content,  :due_date, :user_id, :list_id)
    end

    def find_user
      if params[:user_id]
          begin
          @user = User.find(params[:user_id])
          rescue
              redirect_to users_path
          end
      end
  end

  def find_list
    if params[:list_id]
        begin
        @list = List.find(params[:list_id])
        rescue
            redirect_to lists_path
        end
    end
  end
end
