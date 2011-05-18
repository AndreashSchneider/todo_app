class AufgabenController < ApplicationController
  # GET /aufgaben
  # GET /aufgaben.xml
  helper_method :sort_column, :sort_direction 
  def index
    @aufgaben = Aufgabe.search(params[:search],get_suchbedingung).order(sort_column + ' ' + sort_direction).paginate(:per_page => 25, :page =>params[:page]) 
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
          # Neue Suche mit mehreren Worten ##########################################	
          suchstring="#{params[:search]}" unless params[:search].nil?
          # String auseinanderbauen und % Zeichen einfügen
          sArray= suchstring.split unless suchstring.nil? 
          
           suchen=''
          unless sArray.nil? 
          sArray.each {|begriff|
            suchen = suchen+'%'+begriff
                 }
         verschl_suchen=' '
         # das erste Prozentzeichen kann wegfallen, da schon im suchen enthalten
         if suchstring.nil?
           verschl_suchen=' '
         else
           verschl_suchen = suchen  
         end
         conditions = " ( upper(aufgabe) like upper('"+verschl_suchen.to_s.upcase+"%') 
                       OR projekt like ('"+suchen+"%') 
                       OR upper(information) like (upper('"+suchen+"%'))
                       OR zustaendig like ('"+suchen+"%'))" unless params[:search].nil?
           end                   
         # Ende -Neue Suche mit mehreren Worten ##########################################
         
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
         
         
         
         # Private Projekte nicht automatisch anzeigen (nur explizit)    
          unless params[:privat].nil? then 
           unless params[:privat].to_s == 'alle'
             if conditions.nil?      
               conditions = " privat = '"+params[:privat].to_s+"'"
             else 
               conditions= conditions+" and privat = '"+params[:privat].to_s+"'"
             end
           else
             nil
           end 
          else
           if conditions.nil?      
             conditions = " privat = 'N'"
           else 
             conditions= conditions+" and privat = 'N'"
           end       
          end
            
         # Information Projekt nicht automatisch anzeigen (nur explizit)  
          unless params[:projekt].to_s=='Information' then 
            if conditions.nil?      
              conditions = "projekt <> 'Information'" 
            else 
              conditions= conditions+" AND projekt <> 'Information'" 
            end
          end 
                 
          # Protokolle nicht automatisch anzeigen (nur e otokoll'
          unless params[:projekt].to_s=='Protokoll' then 
            if conditions.nil?      
              conditions = "projekt <> 'Protokoll'" 
            else 
              conditions= conditions+" AND projekt <> 'Protokoll'" 
            end   
          end
          
                  # Protokolle nicht automatisch anzeigen (nur e otokoll'
          unless params[:projekt].to_s=='Ruby' then 
            if conditions.nil?      
              conditions = "projekt <> 'Ruby'" 
            else 
              conditions= conditions+" AND projekt <> 'Ruby'" 
            end   
          end
              
               
         # nur die anzeigen die heute bearbeitet werden sollen (30.11.2007)
         
         if params[:aktuell]=='J' then 
           if conditions.nil?
            conditions ="heute_bearbeiten_kz ='J'"
           else
             conditions=  conditions+" and heute_bearbeiten_kz ='J'"
           end
         end   

         if params[:aktuell]=='N' then 
           if conditions.nil?
            conditions ="heute_bearbeiten_kz ='N'"
           else
             conditions=  conditions+" and heute_bearbeiten_kz ='N'"
           end
         end          
        
         # außer wenn explizit gewünscht, die "Tagesinteressanten" an den
         # folgenden Tagen ausblenden und von der Suche ausnehmen.
         # unless params[:aktuell]=='alle u. unwichtige' then 
         #   conditions = conditions+" and (nur_heute_interessant = 'N' OR status = 'Offen'
         #                              OR (nur_heute_interessant= 'J' AND erfasst = date('now')))"
         # end                           
         unless params[:mantis].nil? 
           unless params[:mantis]=='alle' then
             if params[:mantis]=='J' then
               conditions = conditions + " and mantis_nummer is not null"
             else 
               conditions = conditions + " and mantis_nummer is null "
             end
           end
         end
         if params[:datum].to_s.length == 10 then 
           if conditions.nil?
              conditions= "strftime('%Y-%m-%d',erfasst) "+params[:erf_vergl]+" strftime('%Y-%m-%d','"+params[:datum].to_s+"'))" # mysql-variante
                             
           else
              conditions= conditions+" and strftime('%Y-%m-%d',erfasst) "+params[:erf_vergl]+" strftime('%Y-%m-%d','"+params[:datum].to_s+"')" #mysql-Variante
              # oracle variante " and erfasst > date('"+params[:datum].to_s+"','yyyy-mm-dd')"
           end
         end 
        
         if params[:termin].to_s.length == 10 then 
           if conditions.nil?
              conditions= "( strftime('%Y-%m-%d',termin) "+params[:termin_vergl]+" strftime('%Y-%m-%d','"+params[:termin].to_s+"'))"
           else
              conditions= conditions+" and ( strftime('%Y-%m-%d',termin) "+params[:termin_vergl]+" strftime('%Y-%m-%d','"+params[:termin].to_s+"'))"       
           end    
         end   
                  
         if params[:erledigt_am].to_s.length == 10 then 
           if conditions.nil?
              conditions= "( strftime('%Y-%m-%d',erledigt_am) "+params[:erledigt_vergl]+" strftime('%Y-%m-%d','"+params[:erledigt_am].to_s+"'))"
           else
              conditions= conditions+" and ( strftime('%Y-%m-%d',erledigt_am) "+params[:erledigt_vergl]+" strftime('%Y-%m-%d','"+params[:erledigt_am].to_s+"'))"       
           end    
         end   
               
         if params[:mantis_nr].to_s.length > 3 then
           if conditions.nil? then
              conditions = "mantis_nummer = "+params[:mantis_nr].to_s
           else 
             conditions = conditions+" and mantis_nummer ="+ params[:mantis_nr].to_s 
           end
         end
         return conditions
     end
end
