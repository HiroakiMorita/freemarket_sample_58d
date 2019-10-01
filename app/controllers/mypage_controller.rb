class MypageController < ApplicationController

  before_action :move_to_index
  before_action :card_info

  def index
  end

  def logout
  end

  def identification
  end

  def profile
  end 

  #ヘッダー分岐前のためログイン確認で定義
  private
  def move_to_index
    redirect_to action: :root_path unless user_signed_in?
  end

  def card_info
    @card = Card.where(user_id: current_user.id)
  end
end