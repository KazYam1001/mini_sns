class CardsController < ApplicationController
  before_action :set_api_key, only: [:index, :create]

  def index

  end

  def new
  end

  def create
    begin
      customer = Payjp::Customer.create(
        description: 'test',
        card: params[:payjp_token]
      )
      raise if customer.cards.count == 0
    rescue => exception
      render :new and return
    end
    if current_user.cards.create(customer_id: customer.id)
      if params[:register]
        redirect_to complete_registration_path
      else
        redirect_to cards_path
      end
    else
      render :new
    end
  end

  private

  def set_api_key
    Payjp.api_key = Rails.application.credentials[:payjp][:secret_key]
  end

end
