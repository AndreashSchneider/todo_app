class CommentsController < ApplicationController
before_filter :authenticate
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

def create
    $index = @index||0
    farben =['0000ff','003300','FF69BF','9969BF','452E7B','330000','99B200','e9967a','5672FC','A50021','5F5F5F']
    letzter_kommentar = Comment.last
    unless letzter_kommentar.nil? then
      if params[:neuer]=='1'       
         $index = farben.index(letzter_kommentar.farbe)+1 unless letzter_kommentar.farbe.nil?
      else 
        $index = farben.index(letzter_kommentar.farbe) unless letzter_kommentar.farbe.nil?
      end
    end
    @farbe = farben[$index]
    p "farbe ist #{@farbe}"
    @comment = Comment.create!(params[:comment])
    @comment.body="<font color='##{@farbe}'>#{@comment.body} </font>"
    @comment.farbe=@farbe
    @comment.save
   flash[:notice] = "Vielen Dank fuer Ihre Meinung!"
   respond_to do |format|
     format.html { redirect_to comments_path }
     format.js
   end
 end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

 def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_path }
      format.js
    end
  end
private 
   def authenticate 
     deny_access unless signed_in?
   end
end
