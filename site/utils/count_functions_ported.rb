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
NOT_PORTED = []
STUBS = []
MOVED = []

ZONE = 'Zone memory management, replaced with Eiffel memory model'

MOVED_EXPL = {
  'Expand4' => 'Video upscaling, covered by SDL',
  'AllocLow' => 'DOS memory allocation, not needed in Eiffel',
  'I_BaseTiccmd' => 'Simplified out',
  'BeginRead' => 'Originally empty, simplified out',
  'I_EndRead' => 'Originally empty, simplified out',
  'GetHeapSize' => 'Originally unused',
  'I_HandleSoundTimer' => 'Originally unused',
  'InitMusic' => 'Originally empty, simplified out',
  'I_QrySongPlaying' => 'Originally unused',
  'SetSfxVolume' => 'Originally unused',
  'I_SoundDelTimer' => 'Not needed with SDL',
  'SoundSetTimer' => 'Not needed with SDL',
  'I_SubmitSound' => 'Not needed with SDL',
  'ZoneBase' => 'Memory management, not needed in Eiffel',
  'InitExpand' => 'Video upscaling, covered by SDL',
  'InitExpand2' => 'Video upscaling, covered by SDL',
  'SwapLONG' => 'File endianness handling, replaced with Eiffel features',
  'SwapSHORT' => 'File endianness handling, replaced with Eiffel features',
  'addsfx' => 'Sound handling, covered by SDL',
  'createnullcursor' => 'X11 video output code, replaced with SDL',
  'filelength' => 'Get file length, replaced with Eiffel features',
  'getsfx' => 'Legacy sound interface, replaced with SDL',
  'grabsharedmemory' => 'X11 video handling, replaced with SDL',
  'myioctl' => 'Legacy sound interface, replaced with SDL',
  'strupr' => 'Upcase a string, replaced with Eiffel features',
  'Z_ChangeTag2' => 'Zone memory management, replaced with Eiffel GC',
  'Z_CheckHeap' => ZONE,
  'Z_ClearZone' => ZONE,
  'Z_DumpHeap' => ZONE,
  'Z_FileDumpHeap' => ZONE,
  'Z_Free' => ZONE,
  'Z_FreeMemory' => ZONE,
  'Z_FreeTags' => ZONE,
  'Z_Init' => ZONE,
  'Z_Malloc' => ZONE
}.transform_keys(&:downcase)

C_DATA.each do |cfunc|
  eif = EIFFEL_DATA.find { |e| e[:ename] == cfunc[:cname] }
  moved_expl = MOVED_EXPL[cfunc[:cname]]
  if moved_expl
    MOVED << {
      **cfunc,
      explanation: moved_expl
    }
  elsif eif && !eif[:stub]
    c_to_e_frac = eif[:eloc].to_f / cfunc[:cloc]
    JOINED << {
      **eif,
      **cfunc,
      c_to_e_frac: c_to_e_frac,
      c_to_e: c_to_e_frac.round(1)
    }
  elsif eif && eif[:stub]
    c_to_e_frac = eif[:eloc].to_f / cfunc[:cloc]

    STUBS << {
      **eif,
      **cfunc,
      c_to_e_frac: c_to_e_frac,
      c_to_e: c_to_e_frac.round(1)
    }
  else
    NOT_PORTED << cfunc
  end
end


MOVED.sort_by! { |j| [j[:c_to_e_frac], j[:cloc]] }
MOVED.reverse!

STUBS.sort_by! { |j| [j[:c_to_e_frac], j[:cloc]] }
STUBS.reverse!

JOINED.sort_by! { |j| [j[:c_to_e_frac], j[:cloc]] }
JOINED.reverse!

ANS = {
  total_c: C_DATA.count,
  ported: JOINED.count + MOVED.count,
  ported_ratio: ((JOINED.count + MOVED.count).to_f / C_DATA.count * 100).round(2),
  stubbed_ratio: (STUBS.count.to_f / C_DATA.count * 100).round(2),
  funcs: JOINED,
  stubbed: STUBS,
  not_ported: NOT_PORTED,
  moved: MOVED
}

puts JSON.parse(JSON.dump(ANS)).to_yaml
