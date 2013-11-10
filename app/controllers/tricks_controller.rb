class TricksController < ApplicationController
  before_filter :authenticate_tricker!, :except => [:show, :index]
  
  # GET /tricks
  # GET /tricks.json
  def index
    @tricks = Trick.order(:name)
    @tricks = Trick.order(params[:sort]) if params[:sort]
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tricks }
    end
  end

  def order_by_combos
    @tricks = Trick.order_by_combo

    respond_to do |format|
      format.html # { redirect_to tricks_url, :notice => "mmmmmmmeeeeeh" }# index.html.erb 
      format.json { render json: @tricks }
    end
  end

  # GET /tricks/1
  # GET /tricks/1.json
  def show
    @trick = Trick.find(params[:id])
    @combos = @trick.combos.uniq
    get_tricks_for_all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trick }
    end
  end

  # GET /tricks/new
  # GET /tricks/new.json
  def new
    @trick = Trick.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trick }
    end
  end

  # GET /tricks/1/edit
  def edit
    @trick = Trick.find(params[:id])
    if !(current_tricker.id.equal? @trick.tricker_id) && !current_tricker.try(:admin?)
      respond_to do |format|
        format.html { redirect_to @trick, alert: 'You need admin privileges for that action!' }
        format.json { head :no_content }
      end
    end
  end

  # POST /tricks
  # POST /tricks.json
  def create
    @trick = Trick.new(params[:trick])
    @trick.tricker_id = current_tricker.id

    respond_to do |format|
      if @trick.save
        format.html { redirect_to @trick, notice: 'Trick was successfully created.' }
        format.json { render json: @trick, status: :created, location: @trick }
      else
        format.html { render action: "new" }
        format.json { render json: @trick.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tricks/1
  # PUT /tricks/1.json
  def update
    @trick = Trick.find(params[:id])

    respond_to do |format|
      if @trick.update_attributes(params[:trick])
        format.html { redirect_to @trick, notice: 'Trick was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trick.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tricks/1
  # DELETE /tricks/1.json
  def destroy
    @trick = Trick.find(params[:id])

    # Get all the combos associated with this trick
    @trick.combos.uniq.each do |combo|
      # Get the number of times the trick appears in this combo & subtract from total num of tricks
      @no_tricks = combo.no_tricks
      @no_duplicates = combo.tricks.where(:name => @trick.name).length
      combo.no_tricks = @no_tricks - @no_duplicates
      # If a combo ends up with less than 2 tricks, delete it
      @combos_destroyed = 0
      if (combo.no_tricks < 2)
        combo.destroy
        @combos_destroyed += 1
      else
        # Update the indexes of the remaining tricks in the combo
        @index = 1
        combo.elements.each do |elem|
          if elem.trick.name != @trick.name
            elem.index = @index
            elem.save
            @index += 1
          else
            elem.delete
          end
        end
      end
    end

    # craft response message
    @name = @trick.name
    if @combos_destroyed
      @message = '\''+@name+'\' and '+@combos_destroyed.to_s+ ' of its combos were successfully removed from the database.'
    else
      @message = '\''+@name+'\' was successfully removed from the database.'
    end

    # Destroy the trick itself
    @trick.destroy

    respond_to do |format|
      format.html { redirect_to tricks_url, notice: @message }
      format.json { head :no_content }
    end
  end

  private
    def get_tricks_for_all
      @tricks_names = []
      @combos.each do |combo|
        @index = 1
        @tricks = []
        combo.elements.length.times do
          @tricks << combo.elements.where(:index=> @index).first.trick.name
          @index += 1
        end
        @tricks_names << @tricks
      end
    end

end
