class CombosController < ApplicationController
  before_filter :authenticate_tricker!, :except => [:show]
  
  # GET /combos
  # GET /combos.json
  def index
    @combos = Combo.page(params[:page]).per(10).order('updated_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @combos }
    end
  end

  def my_combos
    @new_combo = Combo.new
    @new_combo.execution = Video.new

    collection = current_tricker.combos
    if params[:list]
      @list = current_tricker.lists.find_by_id(params[:list])
      collection = @list.combos if @list
    end
    @combos = collection.page(params[:page]).per(10).order('updated_at DESC')
    # @combos = collection.order(params[:sort]) if params[:sort]
    # @combos = @combos.page(params[:page])....

    if request.xhr?
      render partial: 'combos_list'
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @combos }
        format.js
      end
    end
  end

  # GET /combos/1
  # GET /combos/1.json
  def show
    @combo = Combo.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @combo }
    end
  end

  # GET /combos/new
  # GET /combos/new.json
  def new
    @combo = Combo.new
    @combo.execution = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @combo }
    end
  end

  # GET /combos/1/edit
  def edit
    @combo = Combo.find(params[:id])
    get_tricks
    @combo.execution = Video.new unless !@combo.execution.nil?

    if !(current_tricker.id.equal? @combo.tricker_id) && !current_tricker.try(:admin?)
      respond_to do |format|
        format.html { redirect_to @combo, alert: 'You need admin privileges for that action!' }
        format.json { head :no_content }
      end
    end
  end

  # POST /combos
  # POST /combos.json
  def create
    @combo = Combo.create
    @combo.execution = Video.new
    @combo.tricker_id = current_tricker.id

    remove_destroyed

    @combo.no_tricks = @trick_ids.length
    
    create_combo_elements

    update_lists
    update_execution

    @combo.render_sequence

    respond_to do |format|
      if @combo.save
        format.html { redirect_to my_combos_path, notice: 'Combo was successfully created.' }
        format.json { render json: @combo, status: :created, location: @combo }
      else
        format.html { render action: "new" }
        format.json { render json: @combo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /combos/1
  # PUT /combos/1.json
  def update
    @combo = Combo.find(params[:id]) 

    remove_destroyed

    @combo.no_tricks = @trick_ids.length

    # If after the editing the combo has < 2 tricks, return with error message
    if @combo.no_tricks < 2
      redirect_to edit_combo_path(@combo), alert: 'A combo must consist of at least two tricks!'
      return
    end

    # Delete all current combo elements, and recreate the new ones
    @combo.elements.delete_all

    create_combo_elements

    update_lists
    update_execution

    @combo.render_sequence

    respond_to do |format|
      if @combo.save
        format.html { redirect_to my_combos_path, notice: 'Combo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @combo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /combos/1
  # DELETE /combos/1.json
  def destroy
    @combo = Combo.find(params[:id])
    @combo.destroy

    respond_to do |format|
      format.html { redirect_to my_combos_url, notice: 'Combo was successfully removed from the database.' }
      format.json { head :no_content }
    end
  end

  def generate_random
    @combo = Combo.create
    @combo.tricker_id = current_tricker.id

    # 1. randomly select number of tricks 
    @max_no_tricks = 10
    @no_tricks = rand(2..@max_no_tricks)
    @combo.no_tricks = @no_tricks

    # 2. randomly select the @no_tricks tricks
    if current_tricker.tricking_style.tricks.empty?
      # if no trick list is present, choose from all tricks in the database (admin's tricks & user created tricks)
      @collection = Trick.where(:tricker_id => [nil, current_tricker.id])
    else
      # otherwise filter by tricker's style
      @collection = current_tricker.tricking_style.tricks
    end
    
    generate_and_redirect
  end

  def generate_custom # v1
    @combo = Combo.create
    @combo.tricker_id = current_tricker.id

    @filter = params[:filter]
    @no_tricks = params[:no_tricks].to_i
    @combo.no_tricks = @no_tricks

    if (@filter.eql?"database") || (current_tricker.tricking_style.tricks.empty?)
      # if no trick list is present, choose from all tricks in the database (admin's tricks & user created tricks)
      @collection = Trick.where(:tricker_id => [nil, current_tricker.id])
    else
      # otherwise filter by tricker's style
      @collection = current_tricker.tricking_style.tricks
    end

    generate_and_redirect
  end

  # deprecated... loads in modal now
  def generate_options
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

  def remove_destroyed
    @trick_ids = params[:combo][:trick_ids]
    @trick_ids.reject! { |c| c.empty? }
    @tricks_attributes = params[:combo][:tricks_attributes]

    # Formtastic submits some ridiculous parameters, especially for dynamically added/removed tricks
    # In the tricks_attributes hash, each trick in the combo has its own key and value
    @i = 0
    if @tricks_attributes
      @tricks_attributes.each do |key,value|
        # Value is also a hash. The "_destroy" key takes two values:
        # - "1" if the trick was deleted (which means the user clicked on the remove_nested_fields link), and
        # - "false" otherwise
        # What I do here is find which tricks from the provided trick_ids were destroyed,
        # and I mark them for deletion from the tricks involved in the combo
        if value[:_destroy].to_s == "1"  
          @trick_ids[@i] = ""
        end
        @i += 1
      end
    end
    # and here is how the delete happens... by eliminating empty values from trick_ids
    @trick_ids.reject! { |c| c.empty? }
  end

  def create_combo_elements
    # iterate through tricks added, and create all associations one by one!
    @index = 1
    @trick_ids.each do |id|
      Element.create(index: @index, combo_id: @combo.id, trick_id: id);
      @index += 1
    end
  end

  def update_lists
    @list_ids = params[:combo][:list_ids]
    @list_ids = @list_ids.reject! { |c| c.empty? }

    # when you play with indices in lists, you have to change this code!

    @combo.lists.each do |l|
      l.combos.delete(@combo)
    end

    @list_ids.each do |id|
      List.find(id).combos << @combo
    end
  end

  def generate_and_redirect
    @random = @collection.order("RANDOM()").map &:id
    @trick_ids = []
    @index = 0
    @no_tricks.times do
      @trick_ids << @random[@index]
      if @index < @collection.length-1
        @index += 1
      else
        # if the trick list has less tricks than @no_tricks, start over
        @index = 0
      end
    end

    # 3. create the combo elements for the randomly selected tricks
    create_combo_elements

    @combo.render_sequence

    # 4. redirect to edit combo page.
    respond_to do |format|
      if @combo.save
        format.html { redirect_to my_combos_path, notice: 'A '+@no_tricks.to_s+'-trick combo was successfully generated!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @combo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_execution
    new_execution = params[:combo][:execution_attributes]

    if new_execution[:url].present?
      @combo.execution.url = new_execution[:url]

      unless new_execution[:start_time].present?
        @combo.execution.start_time = nil
      else
        @combo.execution.start_time = new_execution[:start_time].to_i
      end
      
      unless new_execution[:end_time].present?
        @combo.execution.end_time = nil
      else
        @combo.execution.end_time = new_execution[:end_time].to_i
      end

      @combo.execution.save
    else
      @combo.execution.delete
    end
  end
end
