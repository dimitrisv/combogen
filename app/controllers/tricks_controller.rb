class TricksController < ApplicationController
  # GET /tricks
  # GET /tricks.json
  def index
    @tricks = Trick.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tricks }
    end
  end

  # GET /tricks/1
  # GET /tricks/1.json
  def show
    @trick = Trick.find(params[:id])

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
  end

  # POST /tricks
  # POST /tricks.json
  def create
    @trick = Trick.new(params[:trick])

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
    @trick.destroy

    respond_to do |format|
      format.html { redirect_to tricks_url }
      format.json { head :no_content }
    end
  end
end
