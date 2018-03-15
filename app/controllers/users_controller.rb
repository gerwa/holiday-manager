class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => I18n.t('messages.accessdenied')
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => I18n.t('messages.userupdated')
    else
      redirect_to users_path, :alert => I18n.t('messages.unableupdateuser')
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => I18n.t('messages.userdeleted')
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => I18n.t('messages.accessdenied')
    end
  end

  def secure_params
    params.require(:user).permit(:role)
  end

end
