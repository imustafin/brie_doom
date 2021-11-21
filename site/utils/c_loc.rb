require 'nokogiri'

class CLoc
  attr_reader :loc

  def initialize(filename)
    xml = File.open(filename) { |f| Nokogiri::XML(f) }

    @loc = xml
      .at_xpath('//CCCC_Project/module_summary/lines_of_code[@level="2"]/@value')
      .value
      .to_i
  end
end
