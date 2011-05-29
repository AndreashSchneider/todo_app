class AufgabenController < ApplicationController
 before_filter :authenticate #, :only=>[:edit, :update]
  # GET /aufgaben
  # GET /aufgaben.xml
  helper_method :sort_column, :sort_direction 
  def index
   # @aufgaben = Aufgabe.search(params[:search],get_suchbedingung,date_where).
   #               order(sort_column + ' ' + sort_direction).paginate(:per_page => 25, :page =>params[:page]) 
    @aufgaben = Aufgabe.search(suchbedingung).
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
   def get_suchbedingung
         
         
         # mehrfach Auswahl von Status in Combobox auswerten      
         conditions2 =" upper(status) like upper('#{params[:status]}')" unless params[:status].nil?
         stati=''
         params[:status].each { |text| stati=stati+ ",'"+text+"'" } unless params[:status].nil?
         # da alle ein führendes Komma erhalten haben hier stati[1..-1] ;-)
         conditions2=" status in ("+ stati[1..-1]+")" unless params[:status].nil?   
         
         # mehrfach Auswahl von Projekten in Combobox auswerten 
         x=''
         params[:projekt].each { |text| x=x+ ",'"+text+"'" } unless params[:projekt].nil?
         # da alle ein führendes Komma erhalten haben hier x[1..-1] ;-)
         conditions3=" projekt in ("+ x[1..-1]+")" unless params[:projekt].nil?
         
         # entweder 
         if  params[:search].nil? then 
           conditions = conditions2 unless params[:status].nil?
         end    
         unless (params[:search].nil? or  params[:status].nil?)
           conditions = conditions+' AND '+conditions2
         end
         # wenn beide voherigen Bedingungen null => dann ohne AND sonst mit ...
         if  (params[:search].nil? and  params[:status].nil?) then
           unless params[:projekt].nil? then conditions = conditions = conditions3; end;
         else
           unless params[:projekt].nil? then conditions = conditions = conditions+' AND '+conditions3; end;
         end    
         
         
  

                 


         return conditions2
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
         bedingung  =(bedingung||Aufgabe).where("privat= ?",params[:privat])
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


        bedingung
     end
 private 
   def authenticate 
     deny_access unless signed_in?
   end
end
