class UsersController < ApplicationController
before_action :require_user_logged_in, only: [:index, :show]  
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
    @favorites = Favorite.where("user_id = ?", @user)
  end

  def new
     @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  # 特定のユーザーがお気に入りした投稿の一覧
  def likes
    @user = User.find(params[:id])
    @microposts = @user.likes.page(params[:page])
    counts(@user)
    # 送られたidを使ってユーザーを取ってくる
    # @userがお気に入りをしたmicropostsを取ってくる
  end
  
  def fav_microposters
    @micropost = Micropost.find(params[:id])
    @fav_microposters = @micropost.fav_microposters.page(params[:page])
    counts(@user)
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end