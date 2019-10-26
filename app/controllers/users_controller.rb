class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def follow
    if User.exists?(params[:id]) && User.exists?(params[:other_id])
      user = User.find(params[:id])
      other_user = User.find(params[:other_id])
      unless followed?(other_user, user)
        user.follow(other_user)
      end
    else
      redirect_to root_url
    end
  end

  def unfollow
    if User.exists?(params[:id]) && User.exists?(params[:other_id])
      user = User.find(params[:id])
      other_user = User.find(params[:other_id])
      user.unfollow(other_user)
    else
      redirect_to root_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                        :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      (redirect_to(root_url) && flash[:danger] = "Please log in.") unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def followed?(followed_user, user)
      user.following.include?(followed_user)
    end

end
