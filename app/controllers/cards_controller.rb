class CardsController < ApplicationController
  def new

  end

  def create
    redirect_to user_registration_path
  end
end
