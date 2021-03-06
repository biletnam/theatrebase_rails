class PasswordResetsController < ApplicationController

  include Shared::GetUserHelper
  include Shared::ViewsComponentsHelper

  before_action -> { get_user_by_email(params[:email]) }, only: [:edit, :update]
  before_action :valid_user,                              only: [:edit, :update]
  before_action :check_expiration,                        only: [:edit, :update]
  before_action :get_page_title

  def new
  end

  def create
    @user = User.find_by_email(params[:password_reset][:email].downcase)
    if !@user
      flash.now[:error] = 'EMAIL ADDRESS NOT FOUND'
      render :new
    elsif !@user.activated_at
      flash[:error] = 'ACCOUNT NOT YET ACTIVATED - PLEASE CHECK YOUR EMAIL FOR ACCOUNT ACTIVATION INSTRUCTIONS'
      redirect_to root_path
    else
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = 'PLEASE CHECK YOUR EMAIL FOR PASSWORD RESET INSTRUCTIONS'
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    if password_blank?
      @user.errors.add(:password, 'Password cannot be blank')
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = 'PASSWORD HAS BEEN RESET'
      redirect_to @user
    else
      render :edit
    end
  end

  private

    def user_params
      params
        .require(:user)
        .permit(:password,
                :password_confirmation)
        .merge( updater_id: @user.id,
                reset_digest: nil,
                reset_sent_at: nil)
    end

    def valid_user
      unless (@user && @user.activated_at? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_path
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:error] = 'PASSWORD RESET TOKEN HAS EXPIRED'
        redirect_to new_password_reset_url
      end
    end

    def get_page_title
      @page_title = ['new', 'create'].include?(params[:action]) ?
        'Request password reset link' :
        "Reset password: #{get_user_page_title}"
    end

    def password_blank?
      params[:user][:password].blank?
    end
end
