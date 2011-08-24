class KarteiController < ApplicationController
  # GET /kartei
  # GET /kartei.xml
  def index
    @kartei = Karte.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @kartei }
    end
  end

  # GET /kartei/1
  # GET /kartei/1.xml
  def show
    @karte = Karte.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @karte }
    end
  end

  # GET /kartei/new
  # GET /kartei/new.xml
  def new
    @karte = Karte.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @karte }
    end
  end

  # GET /kartei/1/edit
  def edit
    @karte = Karte.find(params[:id])
  end

  # POST /kartei
  # POST /kartei.xml
  def create
    @karte = Karte.new(params[:karte])

    respond_to do |format|
      if @karte.save
        format.html { redirect_to(@karte, :notice => 'Karte was successfully created.') }
        format.xml  { render :xml => @karte, :status => :created, :location => @karte }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @karte.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /kartei/1
  # PUT /kartei/1.xml
  def update
    @karte = Karte.find(params[:id])

    respond_to do |format|
      if @karte.update_attributes(params[:karte])
        format.html { redirect_to(@karte, :notice => 'Karte was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @karte.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /kartei/1
  # DELETE /kartei/1.xml
  def destroy
    @karte = Karte.find(params[:id])
    @karte.destroy

    respond_to do |format|
      format.html { redirect_to(kartei_url) }
      format.xml  { head :ok }
    end
  end
end
