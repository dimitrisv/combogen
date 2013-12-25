class TricksController < ApplicationController
  before_filter :authenticate_tricker!, :except => [:show, :index]
  
  # GET /tricks
  # GET /tricks.json
  def index
    @new_trick = Trick.new

    # retrieve tricks
    @collection = params[:collection]
    @tricks = Trick.where(:tricker_id => 1)
    unless !@collection
      if @collection.eql? "all"
        @tricks = Trick.scoped
      elsif @collection.eql? "user"
        # get all tricks that are not from admin users ???
        # change this
        @tricks = Trick.where(Trick.arel_table[:tricker_id].not_eq(1))
        # what about my own tricks?
        # if tricker_signed_in?
        #   @my_tricks = current_tricker.tricks.order(:name)
        # end
      end
    end
    
    # sort tricks
    @sort = params[:sort]
    unless !@sort
      if @sort.eql? "difficulty"
        @tricks = @tricks.order(:difficulty).order(:name)
      elsif @sort.eql? "trick_type"
        @tricks = @tricks.order(:trick_type).order(:name)
      elsif @sort.eql? "combos"
        @tricks = @tricks.order_by_combo
      end
    else
      @tricks = @tricks.order(:name)
    end
    
    get_trick_types
    get_difficulty_classes
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
    @combos = @trick.combos.uniq # Combo.where(:id => @trick.combos.uniq.map(&:id))

    if tricker_signed_in?
      #filter_by_tricking_style
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trick }
    end
  end

  # GET /tricks/new
  # GET /tricks/new.json
  def new
    @trick = Trick.new
    get_trick_types
    get_difficulty_classes

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trick }
    end
  end

  # GET /tricks/1/edit
  def edit
    @trick = Trick.find(params[:id])
    get_trick_types
    get_difficulty_classes
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
        format.html { redirect_to tricks_path, notice: 'Trick was successfully created.', params: { :collection => "user" } }
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

  def get_trick_types
    @trick_types = [ "Kick", "Flip", "Twist", "EX", "Invert", "Groundmove", "Kick, Flip",
      "Flip, Twist", "Kick, Twist", "Kick, Flip, Twist" ]
  end

  def get_difficulty_classes
    @difficulty_classes = [ "A", "B", "C", "D", "E", "F", "FND", "EX" ]
  end

  def filter_by_tricking_style
    # find all non user created combos
    @trickers = Tricker.all.map(&:id)
    @trickers.delete(current_tricker.id)
    @combos = @combos.where(:tricker_id => @trickers)
    
    # query all combo elements, keeping only the ones whose tricks are included in the trick list
    @trick_list = current_tricker.tricking_style.tricks.map(&:id)
    @elements = Element.where(:combo_id=>@combos.map(&:id)).where(:trick_id => @trick_list)

    @combos = @elements.map(&:combo_id).uniq
    
    # check which combos are complete?
    # get combo.no_tricks then compare with my collections no_tricks for this combo
    # for each individual combo in the collection, count its tricks... if equal to no_tricks
  end

end
