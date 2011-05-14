class ProjekteController < ApplicationController
  # GET /projekte
  # GET /projekte.xml
  def index
    @projekte = Projekt.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projekte }
    end
  end

  # GET /projekte/1
  # GET /projekte/1.xml
  def show
    @projekt = Projekt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @projekt }
    end
  end

  # GET /projekte/new
  # GET /projekte/new.xml
  def new
    @projekt = Projekt.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @projekt }
    end
  end

  # GET /projekte/1/edit
  def edit
    @projekt = Projekt.find(params[:id])
  end

  # POST /projekte
  # POST /projekte.xml
  def create
    @projekt = Projekt.new(params[:projekt])

    respond_to do |format|
      if @projekt.save
        format.html { redirect_to(@projekt, :notice => 'Projekt was successfully created.') }
        format.xml  { render :xml => @projekt, :status => :created, :location => @projekt }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @projekt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projekte/1
  # PUT /projekte/1.xml
  def update
    @projekt = Projekt.find(params[:id])

    respond_to do |format|
      if @projekt.update_attributes(params[:projekt])
        format.html { redirect_to(@projekt, :notice => 'Projekt was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @projekt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projekte/1
  # DELETE /projekte/1.xml
  def destroy
    @projekt = Projekt.find(params[:id])
    @projekt.destroy

    respond_to do |format|
      format.html { redirect_to(projekte_url) }
      format.xml  { head :ok }
    end
  end
end
