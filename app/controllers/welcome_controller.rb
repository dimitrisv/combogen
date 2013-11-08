class WelcomeController < ApplicationController
	before_filter :authenticate_tricker!, :except => [:index]
  def index
  end
  def dashboard
  end
end
