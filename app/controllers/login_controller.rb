class LoginController < ApplicationController
    def index
      render "index"
    end
      
    def create
      user = User.find_by_name params[:name]
      if user && user.authenticate(params[:pass])
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash.now.alert = "Invalid"
        render "index"
      end
    end
    
    def destroy
      session[:user_id] = nil
      #redirect_to root_path
      render "index"
    end
end
