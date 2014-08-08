class TricksController < ApplicationController
  before_filter :authenticate_tricker!
  
  def index
    @tricks = Trick.where(:tricker_id => nil).order('name ASC')
  end

  def order_by_combos
    @tricks = Trick.order_by_combo

    respond_to do |format|
      format.html
      format.json { render json: @tricks }
    end
  end

  def show
    @trick = Trick.find(params[:id])
    @related_combos = @trick.combos.uniq.sample(5) # get all the combos using this trick

    @combos_you_can_do = @trick.combos_in_tricking_style(current_tricker, current_tricker.tricking_style).sample(5)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trick }
    end
  end

  def new
    @trick = Trick.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trick }
    end
  end

  def edit
    @trick = Trick.find(params[:id])
    if !(current_tricker.id.equal? @trick.tricker_id) && !current_tricker.try(:admin?)
      respond_to do |format|
        format.html { redirect_to @trick, alert: 'You need admin privileges for that action!' }
        format.json { head :no_content }
      end
    end
  end

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

  def destroy
    @trick = Trick.find(params[:id])
    @trick.remove_from_combos
    @trick.destroy

    respond_to do |format|
      format.html { redirect_to tricks_url, notice: @message }
      format.json { head :no_content }
    end
  end

end
