class UsersController < ApplicationController
  before_filter :authenticate, :only=>[:edit, :update]
  def show
   @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @title= "Edit User"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success]="Profil updated."
      redirect_to @user
    else 
      @title ="Edit user"
      render 'edit'
    end
  end

  def new
    @user=User.new
  end
  def create   
    @user= User.new(params[:user])
    if @user.save
      sign_in @user 
      flash[:success]=" Welcome to the TodoApp!"
      redirect_to @user
    else
     @title = 'Sign up'
     render 'new'
    end
  end  
 private 
   def authenticate 
     deny_access unless signed_in?
   end
end
