class AufgabenController < ApplicationController
  # GET /aufgaben
  # GET /aufgaben.xml
  helper_method :sort_column, :sort_direction 
  def index
    @aufgaben = Aufgabe.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 2, :page =>params[:page]) 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aufgaben }
    end
  end



  # GET /aufgaben/1
  # GET /aufgaben/1.xml
  def show
    @aufgabe = Aufgabe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aufgabe }
    end
  end

  # GET /aufgaben/new
  # GET /aufgaben/new.xml
  def new
    @aufgabe = Aufgabe.new
    lov_projekte_fuellen
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aufgabe }
    end
  end

  # GET /aufgaben/1/edit
  def edit
    @aufgabe = Aufgabe.find(params[:id])
    lov_projekte_fuellen
  end

  # POST /aufgaben
  # POST /aufgaben.xml
  def create
    @aufgabe = Aufgabe.new(params[:aufgabe])

    respond_to do |format|
      if @aufgabe.save
        format.html { redirect_to(@aufgabe, :notice => 'Aufgabe was successfully created.') }
        format.xml  { render :xml => @aufgabe, :status => :created, :location => @aufgabe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aufgabe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aufgaben/1
  # PUT /aufgaben/1.xml
  def update
    @aufgabe = Aufgabe.find(params[:id])

    respond_to do |format|
      if @aufgabe.update_attributes(params[:aufgabe])
        format.html { redirect_to(@aufgabe, :notice => 'Aufgabe was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aufgabe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aufgaben/1
  # DELETE /aufgaben/1.xml
  def destroy
    @aufgabe = Aufgabe.find(params[:id])
    @aufgabe.destroy

    respond_to do |format|
      format.html { redirect_to(aufgaben_url) }
      format.xml  { head :ok }
    end
  end

  # Damit kann die Werteliste auch dynamisch gefüllt werden.
  def lov_projekte_fuellen
    @projekte = Projekt.find(:all)
    @projektliste =[]
    @projekte.each {|proj| @projektliste << proj.title}
  end
  private  
   def sort_column  
     Aufgabe.column_names.include?(params[:sort]) ? params[:sort] : "id"  
   end  
     
   def sort_direction  
     %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"  
   end
end
