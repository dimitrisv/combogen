class TrickingStylesController < ApplicationController
  before_filter :authenticate_tricker!
  # GET /tricking_styles
  # GET /tricking_styles.json
  def index
    @tricking_styles = TrickingStyle.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tricking_styles }
    end
  end

  # GET /tricking_styles/1
  # GET /tricking_styles/1.json
  def show
    @tricking_style = TrickingStyle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tricking_style }
    end
  end

  # GET /tricking_styles/new
  # GET /tricking_styles/new.json
  def new
    @tricking_style = TrickingStyle.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tricking_style }
    end
  end

  # GET /tricking_styles/1/edit
  def edit
    @tricking_style = TrickingStyle.find(params[:id])
  end

  # POST /tricking_styles
  # POST /tricking_styles.json
  def create
    @tricking_style = TrickingStyle.new
    @tricking_style.tricker_id = current_tricker.id

    assign_attributes

    respond_to do |format|
      if @tricking_style.save
        format.html { redirect_to @tricking_style, notice: 'Tricking style was successfully created.' }
        format.json { render json: @tricking_style, status: :created, location: @tricking_style }
      else
        format.html { render action: "new" }
        format.json { render json: @tricking_style.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tricking_styles/1
  # PUT /tricking_styles/1.json
  def update
    @tricking_style = TrickingStyle.find(params[:id])
    
    assign_attributes

    respond_to do |format|
      if @tricking_style.save
        format.html { redirect_to @tricking_style, notice: 'Your Trick List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tricking_style.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tricking_styles/1
  # DELETE /tricking_styles/1.json
  def destroy
    @tricking_style = TrickingStyle.find(params[:id])
    @tricking_style.destroy

    respond_to do |format|
      format.html { redirect_to tricking_styles_url }
      format.json { head :no_content }
    end
  end

  private

  def assign_attributes
    @tricking_style.name = params[:tricking_style][:name] if params[:tricking_style][:name]
    @tricking_style.description = params[:tricking_style][:description] if params[:tricking_style][:description]
    @tricking_style.tricks = []
    @trick_ids = params[:tricking_style][:trick_ids]
    @trick_ids.reject! { |c| c.empty? }
    @trick_ids.each do |id|
      @tricking_style.tricks << Trick.find(id)
    end
  end

end
