# encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__),
                                   %w[.. example_helper]))

class HelloReport < Prawn::Document
  def to_pdf
         images = [
                ["Type 0", "public/wasserzeichen.png"],
               # ["Type 1", "public/kopf.jpg"]
      ]
  #   Prawn::Document.generate("hello.pdf", :page_size => "A4") do
        images.each do |header, file|
          start_new_page unless header.include?("0")

          image "public/kopf.jpg", :at => [250,780],:scale => 0.5
          image file, :at => [60,180],:scale => 0.75
          font "Helvetica"
          formatted_text_box [ 
           { :text => "Tapezierarbeiten\nLackierarbeiten\nFassadengestaltung\nFußbodenverlegung\nLasurtechniken\nEdelputzarbeiten",
            :styles => [:bold], :size => 11, :color => [100, 100, 0, 50]},
          ], :at => [7, 750], :width => 111, :height => 100

        formatted_text_box [ { :text => "~ ~ ~ ~ ~ ~ ",
            :styles => [:bold], :size => 11, :color => [100, 33, 0, 13]},
          ], :at => [0, 750], :width => 10, :height => 100

        formatted_text_box [ { :text => "Inh. Hans-Peter Vaßen ",
            :styles => [:italic], :size => 11, :color => [100, 33, 0, 13]},
          ], :at => [370, 670], :width => 200, :height => 100

        formatted_text_box [ { :text => "Tulpenweg 27 - 52222 Stolberg\nTel.: (0 24 02) 76 35 25\nFax: (0 2402) 974 45 00\nMobil: (0179)670 50 17\nEmail: anfrage@malerbetrieb-vassen.de\nhttp://www.malerbetrieb-vassen.de",
             :size => 9, :color => [100, 100, 0, 50]},
                     ], :at => [370, 650], :width => 200, :height => 100

          # draw_text'Rechnungsdatum gleich Lieferdatum', :size => 11, :at => [285,620] 



          draw_text'Malerbetrieb Vaßen, Tulpenweg 27, 52222 Stolberg', :size => 9, :at => [0,660] 
          draw_text 'Steuernummer: 202/5424/1471   -   Ust.-ID-Nr.: DE 243789531', :size => 7, :at => [150,7] #, :style => :bold 
          draw_text 'Bankverbindung: Sparkasse Aachen  - BLZ:390 500 00  -  Konto-Nr.:107 134 26 36', :size => 7, :at => [130,0] 

        end
     # end
      render
    end
  end

