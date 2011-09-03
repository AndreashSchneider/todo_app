require File.expand_path(File.join(File.dirname(__FILE__),
                                   %w[.. example_helper]))

  Widths = [50, 90, 170, 90, 90, 50]
  Headers = ["Date", "Patient Name", "Description", "Charges / Payments", 
             "Patient Portion Due", "Balance"]
class HelloReport < Prawn::Document
  def to_pdf
         images = [
                ["Type 0", "#{Prawn::BASEDIR}/data/images/web-links.png"],
                ["Type 2", "#{Prawn::BASEDIR}/data/images/ruport.png"],
                ["Type 3", "#{Prawn::BASEDIR}/data/images/rails.png"],
                ["Type 4", "#{Prawn::BASEDIR}/data/images/page_white_text.png"],
                ["Type 6", "#{Prawn::BASEDIR}/data/images/dice.png"],
      ]

      Prawn::Document.generate("png_types.pdf", :page_size => "A5") do
        images.each do |header, file|
          start_new_page unless header.include?("0")
          text header
          image file, :at => [50,450]
        end
      end
    end
  end
end

