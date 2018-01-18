class MyBaseDeviseController < ActionController::Base
  include Constant

  layout 'session'

  prepend_before_action :check_user!, only: :create

  private

  def check_user!
    return unless is_a?(Devise::SessionsController)
    user = ChannelUser.find_by(phone: params[:user][:phone])

    unless user && user.channel_type == CompanyType::CHANNEL
      flash[:alert] = '用户非法，请联系系统管理员'
      redirect_to '/login'
    end

    if user && user.user_state != UserStatus::ENABLE
      flash[:alert] = '用户被禁用，请联系系统管理员'
      redirect_to '/login'
    end
  end
end
