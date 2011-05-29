class AufgabenController < ApplicationController
 before_filter :authenticate #, :only=>[:edit, :update]
  # GET /aufgaben
  # GET /aufgaben.xml
  helper_method :sort_column, :sort_direction 
  def index
    @aufgaben = suchbedingung.    # liefert eine WHERE-CLAUSE !!
                order(sort_column + ' ' + sort_direction).paginate(:per_page => 25, :page =>params[:page]) 
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
    @aufgabe.user_id = current_user.id
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
    p "erstmal hier "
    @aufgabe.user_id = current_user.id
    p "hier bin ich #{@aufgabe.user_id}"
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
    @projekte = Projekt.where("user_id = ?",current_user.id)
    @projektliste =[]
    @projekte.each {|proj| @projektliste << proj.title}
  end
  private  
   def sort_column  
     Aufgabe.column_names.include?(params[:sort]) ? params[:sort] : "id"  
   end  
     
   def sort_direction  
     %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"  
   end
   def suchbedingung
     if params[:erfasst].to_s.length == 10 then 
       bedingung =(bedingung||Aufgabe).where("date(erfasst) "+params[:erf_vergl]+" DATE(?)", params[:erfasst])
     end
     if params[:termin].to_s.length == 10 then 
       bedingung =(bedingung||Aufgabe).where("date(termin) "+params[:termin_vergl]+" DATE(?)", params[:termin])
     end
     if params[:erledigt_am].to_s.length == 10 then 
       bedingung =(bedingung||Aufgabe).where("date(erledigt_am) "+params[:erledigt_vergl]+" DATE(?)", params[:erledigt_am])
     end 
     if params[:zuletzt_bearbeitet].to_s.length == 10 then 
       bedingung =(bedingung||Aufgabe).where("date(updated_at) "+params[:erledigt_vergl]+" DATE(?)
                                              or date(erfasst) "+params[:erledigt_vergl]+" DATE(?)", 
                                              params[:zuletzt_bearbeitet],params[:zuletzt_bearbeitet]
                                              )
     end 
     if params[:mantis_nr].to_s.length > 3 then 
       bedingung =(bedingung||Aufgabe).where("mantis_nummer = ?", params[:mantis_nr])
     end
     if params[:mantis]=='J' then
       bedingung  =(bedingung||Aufgabe).where("mantis_nummer is not null")
     elsif params[:mantis]=='N' then
       bedingung  =(bedingung||Aufgabe).where("mantis_nummer is null")
     end
     # werden nur wenn angefordert angezeigt !
     unless params[:projekt]=='Information' then 
       bedingung  =(bedingung||Aufgabe).where("projekt <> 'Information'")
     end
     unless params[:projekt]=='Ruby' then 
       bedingung  =(bedingung||Aufgabe).where("projekt <> 'Ruby'")
     end
     unless params[:projekt]=='Protokoll' then 
       bedingung  =(bedingung||Aufgabe).where("projekt <> 'Protokoll'")
     end
     unless params[:privat]=='Alle' then 
       bedingung  =(bedingung||Aufgabe).where("privat= ?",params[:privat]) unless params[:privat].nil?
     end
     suchstring="#{params[:search]}" unless params[:search].nil?
     # String auseinanderbauen und % Zeichen einfügen
     sArray= suchstring.split unless suchstring.nil? 
     suchen=''
     unless sArray.nil? 
     sArray.each do |begriff|
       suchen = suchen+'%'+begriff
     end
     verschl_suchen=' '
     # das erste Prozentzeichen kann wegfallen, da schon im suchen enthalten
     if suchstring.nil?
       verschl_suchen=' '
     else
       verschl_suchen = suchen  
     end         
     bedingung  =(bedingung||Aufgabe).where("upper(aufgabe) like upper(:suchen)
                           or projekt like (:suchen)
                           or upper(information) like :suchen
                           or zustaendig like :suchen",:suchen =>suchen+'%')

     end
     bedingung  =(bedingung||Aufgabe).where("status in (:stati) ",:stati => params[:status]) unless params[:status].nil?   
     bedingung  =(bedingung||Aufgabe).where("projekt in (:projekte) ",:projekte => params[:projekt]) unless params[:projekt].nil? 
     bedingung  =(bedingung||Aufgabe).where("user_id = ?", current_user.id)
     bedingung
   end

 private 
   def authenticate 
     deny_access unless signed_in?
   end
end
