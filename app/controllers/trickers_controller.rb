class TrickersController < ApplicationController
  before_filter :authenticate_tricker!, :only => :show
  def show
    @tricker = Tricker.find(params[:id])
    @combos = @tricker.combos
  end
end