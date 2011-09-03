class VwVokabelnsController < ApplicationController
  # GET /vw_vokabelns
  # GET /vw_vokabelns.xml




 def index
    conditions1=''
   p params[:vergleich]
   unless params[:vergleich].nil? then conditions1 = "AND (k1.folder) "+params[:vergleich]; end
    conditions1 = conditions1+" ('#{params[:folder]}')" # unless (params[:folder].nil?
    conditions2 ="AND k1.sparte IN ('#{params[:sparte]}')" unless params[:sparte].nil?
    unless params[:sparte].nil? then conditions_sparte= "sparte IN ('#{params[:sparte]}')" 
    else 
     conditions_sparte="sparte in ('Entscheidungsvorlage')"
    end
   unless params[:vergleich_kapitel].nil? then conditions3 ="AND k1.kapitel "+params[:vergleich_kapitel]+"('#{params[:kapitel]}')"; end;
    # conditions3 ="AND k1.kapitel <= ('#{params[:kapitel]}')"
    

    
    if  params[:folder].nil? then 
      conditions = conditions2 unless params[:sparte].nil?
      p params[:sparte].to_s
    end 
       
    if  params[:sparte].nil? then 
      conditions = conditions1 unless params[:folder].nil?
    end  
    

    unless (params[:folder].nil? or  params[:sparte].nil?)
      conditions = conditions1.to_s+' '+conditions2.to_s
    end
    conditions = conditions.to_s+' '+conditions3.to_s unless ( conditions.nil? or conditions3.nil?)

    unless params[:search].nil? then
      conditions = conditions +" AND ( answer like '%#{params[:search]}%' or question like '%#{params[:search]}%') "
    end
	  conditions = conditions.gsub("''","'") unless conditions.nil?

  # Warum hier die doppelten Anführungszeichen entfernt werden müssen ist mir nicht völlig klar
  conditions_sparte.gsub!("''","'") unless conditions_sparte.nil?
  @vw_vokabelns= VwVokabeln.find_by_sql(
   "select  k1.id as id,k1.question as question1, k1.answer as answer1, k1.folder as folder1,
       k1.sparte as sparte1, k1.kapitel as kapitel1, not_known_today as not_known_today1,
       (select k2.answer from kartei k2
         order by random() limit 1 ) answer2,
       (select k3.answer from kartei k3    
        order by random() limit 1)  answer3,
       (select count(1) from kartei k4
         where strftime('%d.%m.%Y',k4.aend_dat) = strftime('%d.%m.%Y', date('now','localtime','-1461 days')
        ))  as geloest
    from kartei k1
   where  strftime('%d.%m.%Y',k1.aend_dat) <>  strftime('%d.%m.%Y', date('now','localtime','-1461 days'))
   " +conditions.to_s+"
   order by random()/k1.folder/10 limit 1")     # folder/5 ersetzt durch folder/10 (12.05.2009)    
   #    and k2.id <> k1.id  and k3.id <> k1.id --> wenn ich die Bedingungen rein nehme startet der voki
   p @vw_vokabelns.to_s
  respond_to do |format|
     format.html 
     format.js 
  end
  end 

  # GET /vw_vokabelns/1
  # GET /vw_vokabelns/1.xml
  def show
    @vw_vokabeln = VwVokabeln.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vw_vokabeln }
    end
  end

  # GET /vw_vokabelns/new
  # GET /vw_vokabelns/new.xml
  def new
    @vw_vokabeln = VwVokabeln.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vw_vokabeln }
    end
  end

  # GET /vw_vokabelns/1/edit
  def edit
    @vw_vokabeln = VwVokabeln.find(params[:id])
  end

  # POST /vw_vokabelns
  # POST /vw_vokabelns.xml
  def create
    @vw_vokabeln = VwVokabeln.new(params[:vw_vokabeln])

    respond_to do |format|
      if @vw_vokabeln.save
        format.html { redirect_to(@vw_vokabeln, :notice => 'Vw vokabeln was successfully created.') }
        format.xml  { render :xml => @vw_vokabeln, :status => :created, :location => @vw_vokabeln }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vw_vokabeln.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vw_vokabelns/1
  # PUT /vw_vokabelns/1.xml
  def update
    @vw_vokabeln = VwVokabeln.find(params[:id])

    respond_to do |format|
      if @vw_vokabeln.update_attributes(params[:vw_vokabeln])
        format.html { redirect_to(@vw_vokabeln, :notice => 'Vw vokabeln was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vw_vokabeln.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vw_vokabelns/1
  # DELETE /vw_vokabelns/1.xml
  def destroy
    @vw_vokabeln = VwVokabeln.find(params[:id])
    @vw_vokabeln.destroy

    respond_to do |format|
      format.html { redirect_to(vw_vokabelns_url) }
      format.xml  { head :ok }
    end
  end
end
