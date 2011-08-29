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
def list2
    
    
    if params[:sparte].nil? 
     conditions = " sparte ='Entscheidungsvorlage'"
    else
     conditions = " sparte in ('"+params[:sparte]+"')"
    end
     conditions.gsub!("''","'") unless conditions.nil?
    unless params[:vergleich].nil? then conditions =conditions+ "  AND (folder) "+params[:vergleich]; end
    unless params[:folder].nil? then conditions = conditions+" ('#{params[:folder]}')";  end
    
    # Neue Suche mit mehreren Worten ##########################################	
     suchstring="#{params[:query]}" unless params[:query].nil?
     # String auseinanderbauen und % Zeichen einfügen
     sArray= suchstring.split unless suchstring.nil? 
     
      suchen=''
     unless sArray.nil? 
       sArray.each {|begriff|
         suchen = suchen+'%'+begriff
              }
       
       # das erste Prozentzeichen kann wegfallen, da schon im suchen enthalten
       conditions = conditions+ "AND ( upper(question) like upper('"+suchen+"%') OR upper(answer) like ('"+suchen+"%') )" unless params[:query].nil?
     end                   
    
    # Ende -Neue Suche mit mehreren Worten ##########################################
    @total = Karte.count(:conditions => conditions)    
    @kartei = Karte.find(:all,:conditions =>conditions, :order=>'folder' )
    
    if request.xml_http_request? 
      render :partial=> "kartei_list", :layout=> false
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
  def edit_richtig
    # Test
     p 'hier in Kartei->Edit: '+params[:id].to_s
    @karte = Karte.find(params[:id])
    # 27.04.2007 Nur dann ein Datum eintragen, wenn die Frage nicht heute bereits 
    # herab gestuft wurde !! Diese kann damit mehrmals am Tag entsprechend dem Folder 
    # an die Reihe kommen.
    # p 'Heute ?'+@karte.not_known_today  # läuft auf einen Fehler, daher auskommentiert 02.02.2009
      if @karte.not_known_today == 'N' then 
        @karte.folder= @karte.folder.to_i+1 
        # aktuelle Zeit
        t1=Time.now
        # ohne Sekunden
        t2= Time.mktime( t1.year, t1.month, t1.day)
        p 't2 vor umwandlung '+t2.to_s
        # zurück in die Zukunft !!       
        t2= t2-126230400 # 126144000+86400= 126230400 94608000 
        p 'Insert-Time '+t2.to_s
        @karte.aend_dat=t2
      else 
        @karte.not_known_today = 'N'
        @karte.folder= @karte.folder.to_i+1
      end
      @karte.save
      p 'Folder ist jetzt: '+@karte.folder.to_s
       # render(:partial => '/vw_vokabelns/vw_vokabeln', :actions => 'vw_vokabelns/index', :controller => "vw_vokabelns")
       render :nothing => true

#   respond_to do |format|
#     format.html { redirect_to vw_vokabelns_path }
#     format.js { redirect_to vw_vokabelns_path }
#   end
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
