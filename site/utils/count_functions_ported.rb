# Generate C metrics:
# cccc --lang=c *.c
# anonymous.xml will contain C code metrics

# Generate pretty-printed Eiffel:
# ec -filter ascii -all -batch -verbose

require 'yaml'
require 'json'

require_relative 'eiffel_parser'


# Analyse C code
require 'nokogiri'

xml = File.open('anonymous.xml') { |f| Nokogiri::XML(f) }

C_DATA = []

xml.xpath('//member_function').each do |f|
  name = f.xpath('./name').first.text
  name = name.split('(').first
  cname_orig = name
  name = name.downcase

  declaration = f.xpath("./extent[description='definition']").first

  next unless declaration

  source_reference = declaration.xpath('./source_reference').first

  loc = f.xpath('./lines_of_code').first['value']
  cfile = source_reference['file']
  cline = source_reference['line']

  raise "duplicate C function #{name}" if C_DATA.any? { |x| x[:cname] == name }

  C_DATA << {
    cname: name,
    cname_orig: cname_orig,
    cloc: loc.to_i,
    cfile: cfile,
    cline: cline.to_i
  }
end

# Analyse Eiffel code


EIFFEL_DATA = []


eiffel_root = 'Documentation/brie_doom/**/*'
eiffel_files = Dir.glob(eiffel_root + '.txt') \
  - Dir.glob(eiffel_root + '_chart.txt') \
  - Dir.glob(eiffel_root + '_links.txt') \
  - Dir.glob(eiffel_root + 'index.txt')

eiffel_files.each do |f|
  File.open(f) do |file|
    cluster = f.delete_prefix('Documentation/').delete_suffix('.txt')
    EIFFEL_DATA.push(*EiffelParser.new(file, cluster).parse_file)
  end
end

## Join data
JOINED = []

C_DATA.each do |cfunc|
  EIFFEL_DATA.each do |func|
    if func[:ename] == cfunc[:cname] && !func[:stub]
      c_to_e_frac = func[:eloc].to_f / cfunc[:cloc]
      JOINED << {
        **func,
        **cfunc,
        c_to_e_frac: c_to_e_frac,
        c_to_e: c_to_e_frac.round(1)
      }
    end
  end
end

JOINED.sort_by! { |j| [j[:c_to_e_frac], j[:cloc]] }
JOINED.reverse!

ANS = {
  total_c: C_DATA.count,
  ported: JOINED.count,
  ported_ratio: (JOINED.count.to_f / C_DATA.count * 100).round(2),
  funcs: JOINED
}

puts JSON.parse(JSON.dump(ANS)).to_yaml
