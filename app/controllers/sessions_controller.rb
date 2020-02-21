require 'pry'
class SessionsController < ApplicationController
    def new
        if logged_in?
            redirect_to user_path(current_user)
        end
    end

    def create
       
        @user = User.find_by(name: params[:user][:name])
        #binding.pry
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect_to user_path(@user)
        else
            redirect_to root_path
        end
        
    end

    def omnicreate
       # binding.pry
        @user = User.find_or_create_by(id: auth['uid']) do |u|
            u.name= auth['info']['name']
            u.password= "11111111"
        end
        @user.save
          # binding.pry
       
          session[:user_id] = @user.id
          redirect_to user_path(@user)
    end

    def destroy
        session.delete :user_id
        redirect_to root_path
    end
    private
    def auth
        request.env['omniauth.auth']
      end
end