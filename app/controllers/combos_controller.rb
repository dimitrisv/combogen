class CombosController < ApplicationController
  before_filter :authenticate_tricker!, :except => [:show]
  
  def index
    @combos = Combo.order('updated_at DESC').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @combos }
    end
  end

  def search
    @combos = Combo.search(params[:search], params[:page])
  end

  def my_combos

    collection = current_tricker.combos
    if params[:list]
      @list = current_tricker.lists.find_by_id(params[:list])
      collection = @list.combos if @list
    end
    @combos = collection.order('updated_at DESC').page(params[:page])
    # @combos = collection.order(params[:sort]) if params[:sort]
    # @combos = @combos.page(params[:page])....

    if request.xhr?
      render partial: 'combos_list', locals: {empty_message: 'There are currently no combos in this list.'}
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @combos }
        format.js
      end
    end
  end

  def create
    @combo = Combo.create
    @combo.tricker_id = current_tricker.id

    # Parse combo sequence and fetch trick ids
    trick_names = params[:sequence].split(',') if params[:sequence].present?
    trick_ids = []
    trick_names.each do |trick_name|
      trick = Trick.find_by_name(trick_name) ||
        current_tricker.tricks.create(name: trick_name)
      trick_ids << trick.id
    end
    @combo.create_elements(trick_ids)

    @combo.no_tricks = @combo.tricks.count
    @combo.render_sequence


    # Parse lists and fetch list ids
    list_names = params[:lists].split(',') if params[:lists].present?
    unless list_names.nil?
      list_ids = []
      list_names.each do |list_name|
        list = current_tricker.lists.find_by_name(list_name) ||
          current_tricker.lists.create(name: list_name)
        list_ids << list.id
      end
      @combo.list_ids = list_ids
    end


    @combo.save
    # render partial: 'combo_row', locals: {combo: @combo}

    @combos = current_tricker.combos
    render 'my_combos'
  end

  def destroy
    @combo = Combo.find(params[:id])
    @combo.destroy

    respond_to do |format|
      format.html { redirect_to my_combos_url, notice: 'Combo was successfully removed from the database.' }
      format.json { head :no_content }
    end
  end

  def get_generator_view
    @combo = Combo.find(params[:combo]) rescue nil
    render partial: 'combo_generator_modal'
  end

private

  def get_tricks
    @index = 1
    @tricks = []
    @combo.elements.length.times do
      @tricks << @combo.elements.where(:index=> @index).first.trick
      @index += 1
    end
  end

end
