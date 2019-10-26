class MicropostsController < ApplicationController

  before_action :logged_in_user,  only: [:create, :destroy]
  before_action :correct_user,    only: :destroy

  def index
    if User.exists?(params[:user_id])
      user = User.find(params[:user_id])
      if params[:limit].present?
        limit = params[:limit].to_i;
      end
      @microposts = user.microposts.all
      if params[:following] == "true"
        @microposts = user.feed
      end
      require "json"
      respond_to do |format|
        format.html
        format.json {
          render json: {
            microposts: @microposts.limit(limit).as_json(except:
                                                  [:created_at, :updated_at])}}
      end
    else
      redirect_to root_url
    end
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture, :title)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
