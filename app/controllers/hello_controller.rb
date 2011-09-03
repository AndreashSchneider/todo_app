class HelloController < ApplicationController
   def index
    output = HelloReport.new.to_pdf
    respond_to do |format|
      format.pdf do
        send_data output , :type => "application/pdf",:filename => "hello.pdf",:disposition => "inline"
        # format.pdf { render :pdf => "contents" }
      end
    end
  end
end

