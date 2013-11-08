class CombosController < ApplicationController
  before_filter :authenticate_tricker!, :except => [:show, :index]
  # GET /combos
  # GET /combos.json
  def index
    @combos = Combo.order(:no_tricks)
    @combos = Combo.order(params[:sort]) if params[:sort]
    @combos = @combos.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @combos }
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @combo }
    end
  end

  # GET /combos/1/edit
  def edit
    @combo = Combo.find(params[:id])
    if !(current_tricker.id.equal? @combo.tricker_id) || !current_tricker.try(:admin?)
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
    @combo.tricker_id = current_tricker.id

    remove_destroyed

    @combo.no_tricks = @trick_ids.length
    
    create_combo_elements

    respond_to do |format|
      if @combo.save
        format.html { redirect_to @combo, notice: 'Combo was successfully created.' }
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
      # REDIRECT TO EDIT PAGE WITH ERROR MESSAGE! BOOM!!!
      respond_to do |format|
        format.html { redirect_to edit_combo_path(@combo), alert: 'A combo must consist of at least two tricks!' }
        format.json { head :no_content }
      end
      return
    end

    # Delete all current combo elements, and recreate the new ones
    @combo.elements.delete_all

    create_combo_elements

    respond_to do |format|
      if @combo.save
        format.html { redirect_to @combo, notice: 'Combo was successfully updated.' }
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
      format.html { redirect_to combos_url, notice: 'Combo was successfully removed from the database.' }
      format.json { head :no_content }
    end
  end

def generate_random
  @combo = Combo.create
  @combo.tricker_id = current_tricker.id

  # randomly select number of tricks X
  @max_no_tricks = 10
  @no_tricks = rand(2..@max_no_tricks)
  @combo.no_tricks = @no_tricks

  # create @no_tricks combo elements
  @trick_ids = Trick.limit(@no_tricks).order("RANDOM()").map &:id

  create_combo_elements

  # redirect to edit_random page, where there is an ability to DELETE.
  respond_to do |format|
    if @combo.save
      format.html { redirect_to edit_combo_path(@combo), notice: 'A '+@no_tricks.to_s+'-trick combo was successfully generated!' }
      format.json { head :no_content }
    else
      format.html { render action: "edit" }
      format.json { render json: @combo.errors, status: :unprocessable_entity }
    end
  end
end


private

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
end
