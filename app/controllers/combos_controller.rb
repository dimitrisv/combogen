class CombosController < ApplicationController
  # GET /combos
  # GET /combos.json
  def index
    @combos = Combo.all

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
  end

  # POST /combos
  # POST /combos.json
  def create
    @combo = Combo.create
    @trick_ids = params[:combo][:trick_ids]
    @trick_ids.reject! { |c| c.empty? }
    @combo.no_tricks = @trick_ids.length

    # if it's empty, return an error

    # iterate through tricks added, and create all associations one by one!
    @trick_ids.each do |id|
      Element.create(index: 1, combo_id: @combo.id, trick_id: id);
    end

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
    @combo = Combo.find(params[:id]) # FORCE ERROR, so I can see the params

    @trick_ids = params[:combo][:trick_ids]
    @trick_ids.reject! { |c| c.empty? }
    @combo.no_tricks = @trick_ids.length

    # DELETE ALL THAT ARE DESTROYED in tricks_attributes[][destroy]
    # in the end, if all combo.no_tricks < 2, delete the combo itself

    # HERE, render the proper message. eg. combo was deleted.
    respond_to do |format|
      if @combo.update_attributes(params[:combo])
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
      format.html { redirect_to combos_url }
      format.json { head :no_content }
    end
  end
end
