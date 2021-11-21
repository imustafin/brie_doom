require 'nokogiri'

class CFunc
  attr_reader :functions

  def initialize(filename)
    xml = File.open(filename) { |f| Nokogiri::XML(f) }

    @functions = xml
      .xpath('//member_function')
      .map { |func| parse_function(func) }
      .compact

    names = @functions.map { |x| x[:cname] }

    dups = names.select { |n| names.count(n) > 1 }

    raise "Duplicate funcs #{dups}" unless dups.empty?
  end

  def parse_function(f)
    name = f.xpath('./name').first.text
    name = name.split('(').first
    cname_orig = name
    name = name.downcase

    declaration = f.xpath("./extent[description='definition']").first

    return unless declaration

    source_reference = declaration.xpath('./source_reference').first

    loc = f.xpath('./lines_of_code').first['value']
    cfile = source_reference['file']
    cline = source_reference['line']

    {
      cname: name,
      cname_orig: cname_orig,
      cloc: loc.to_i,
      cfile: cfile,
      cline: cline.to_i
    }
  end
end
