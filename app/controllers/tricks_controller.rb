class TricksController < ApplicationController
  before_filter :authenticate_tricker!
  
  # GET /tricks
  # GET /tricks.json
  def index
    @new_trick = Trick.new

    # retrieve tricks
    @tricks = Trick.where(:tricker_id => nil)
    @collection = params[:collection]
    if !@collection.nil?
      if @collection.eql? "all"
        @tricks = Trick.scoped
      elsif @collection.eql? "user_created"
        # get all tricks that are not from the admin user (id: 1)
        # TODO: We need a better way to label "database/curated" tricks
        @tricks = Trick.where(Trick.arel_table[:tricker_id].not_eq(1))
        @tricks.reject! { |t| current_tricker.tricks.include? t }
      elsif @collection.eql? "my_tricks"
        # what about my own tricks?
        @tricks = current_tricker.tricks
      end
    end
    
    # TODO: sort tricks
    # @sort = params[:sort]
    # unless !@sort
    #   if @sort.eql? "difficulty"
    #     @tricks = @tricks.order(:difficulty).order(:name)
    #   elsif @sort.eql? "trick_type"
    #     @tricks = @tricks.order(:trick_type).order(:name)
    #   elsif @sort.eql? "combos"
    #     @tricks = @tricks.order_by_combo
    #   end
    # else
    #   @tricks = @tricks.order(:name) unless @tricks.empty?
    # end

    # NOTE: SQL is much faster. Try to do it that way.
    @tricks.sort_by! { |t| t.name }
    
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
    @related_combos = @trick.combos.uniq.sample(5) # get all the combos using this trick

    filter_by_tricking_style
    @combos_you_can_do.sample(5)

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

  # Filters a collection of combos using the user's trick list
  # Can be generalized to use any tricking style
  def filter_by_tricking_style
    @combos_you_can_do = @trick.combos.uniq # get all the combos using this trick

    # remove my combos from this list
    @combos_you_can_do.reject! { |c| c.tricker == current_tricker  }
    
    # get the ids of the tricks I can do
    @trick_list = current_tricker.tricking_style.tricks.map(&:id)

    # (style-combo).count == style.count - combo.count
    # this hits the database twice. is there a better way?
    @combos_you_can_do.reject! { |c| ((@trick_list-c.tricks.map(&:id)).count != (@trick_list.count - c.tricks.uniq.map(&:id).count)) }
  end

end
