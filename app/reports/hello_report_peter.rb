require File.expand_path(File.join(File.dirname(__FILE__),
                                   %w[.. example_helper]))
require 'iconv'

  Widths = [50, 90, 170, 90, 90, 50]
  Headers = ["Date", "Patient Name", "Description", "Charges / Payments", 
             "Patient Portion Due", "Balance"]
class HelloReport < Prawn::Document
  def to_pdf
         images = [
                ["Type 0", "public/wasserzeichen.png"],
                ["Type 1", "public/kopf.jpg"],
                ["Type 2", "#{Prawn::BASEDIR}/data/images/ruport.png"],
                ["Type 3", "#{Prawn::BASEDIR}/data/images/rails.png"],
                ["Type 4", "#{Prawn::BASEDIR}/data/images/page_white_text.png"],
                ["Type 6", "#{Prawn::BASEDIR}/data/images/dice.png"],
      ]
      Prawn::Document.generate("hello.pdf", :page_size => "A4") do
        images.each do |header, file|
          start_new_page unless header.include?("0")

          image "public/kopf.jpg", :at => [250,780],:scale => 0.5
          image file, :at => [100,150],:scale => 0.5
          text Iconv.conv('latin1','utf8','áéíóú')
          draw_text'~ Tapezierarbeiten', :size => 11, :at => [5,750] , :style => :bold 
          draw_text'~ Lackierarbeiten', :size => 11, :at => [5,740] , :style => :bold 
          draw_text'~ Fassadengestaltung', :size => 11, :at => [5,730] , :style => :bold 
          draw_text'~ Fussbodenverlegung', :size => 11, :at => [5,720] , :style => :bold 
          draw_text'~ Lasurtechniken', :size => 11, :at => [5,710] , :style => :bold 
          draw_text'~ Edelputzarbeiten', :size => 11, :at => [5,700] , :style => :bold 
          draw_text'Malerbetrieb Vaßen, Tulpenweg 27, 52222 Stolberg', :size => 11, :at => [5,670] 
          draw_text 'Steuernummer: 202/5424/1471   -   Ust.-ID-Nr.: DE 243789531', :size => 6, :at => [150,7] #, :style => :bold 
          draw_text 'Bankverbindung: Sparkasse Aachen  - BLZ:390 500 00  -  Konto-Nr.:107 134 26 36', :size => 6, :at => [130,0] #, :style => :bold 
        end
      end
    end
  end

