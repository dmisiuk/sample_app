class UsersController < ApplicationController
  before_filter :authenticate,  :except => [:show, :new, :create]
  before_filter :correct_user,  :only => [:edit, :update]
  before_filter :admin_user,    :only => [:destroy]
  before_filter :noAuthenticate,:only => [:new, :create]

  def new
  	@user = User.new
  	@title = "Sign up"
  end

  def index
    @users = User.paginate(:page => params[:page], :per_page => 15)
    @title = "All users"
  end

  def show
  	@user = User.find(params[:id])
  	@title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page], :per_page => 10)
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the MTer"
      redirect_to @user
  		# обработка успешного обращения
  	else
  		@title = "Sign up"
  		render 'new'
  	end
  end

  def update
    if @user.update_attributes params[:user]
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end

  end

  def edit
    @title = "Edit user"
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

 def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  private

    def noAuthenticate
      deny_access_to_new if signed_in?
    end



    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
