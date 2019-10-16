class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :new]
  def index
  end
end
