require 'json'
require 'yaml'
require 'rake/clean'

require_relative '../utils/c_loc'
require_relative '../utils/c_func'
require_relative '../utils/eif_func'
require_relative '../utils/combine'

namespace :loc do
  TMP = 'tmp'
  CLEAN.include(TMP)

  C_LOC = TMP + '/c_loc'
  C_FUNCS = TMP + '/c_funcs.json'
  EIF_FUNCS = TMP + '/eif_funcs.json'

  DATA_FUNCTIONS_PORTED = '_data/functions_ported.yml'
  CLOBBER.include(DATA_FUNCTIONS_PORTED)

  task :tmp_dir do
    FileUtils.mkdir_p(TMP)
  end

  namespace :c do
    DOOM = TMP + '/DOOM/linuxdoom-1.10'

    desc 'Downloads DOOM C source code'
    task clone: :tmp_dir do
      Dir.chdir(TMP) do
        if File.exist?('DOOM')
          puts "DOOM already cloned"
        else
          sh "git clone https://github.com/id-Software/DOOM.git"
        end
      end
    end

    desc 'Extract C code LOC'
    task loc: :clone do |_t, args|
      data = nil
      Dir.chdir(DOOM) do
        sh "cccc --lang=c --outdir=locs *.c *.h"
        data = CLoc.new('locs/anonymous.xml')
      end
      File.write(C_LOC, data.loc)
    end

    desc 'Extract C functions stats'
    task funcs: :clone do |_t, args|
      data = nil
      Dir.chdir(DOOM) do
        sh "cccc --lang=c --outdir=funcs *.c"

        data = CFunc.new('funcs/anonymous.xml')
      end
      File.write(C_FUNCS, data.functions.to_json)
    end
  end

  desc 'Everything C-Related'
  task c: ['c:loc', 'c:funcs']

  namespace :eif do
    EIF_IN = '../brie_doom'
    EIF = TMP + '/eif'

    desc 'Make prettified copies of Eiffel classes'
    task :pretty, [:doom_loc] do |_t, args| 
      eif_in = args[:doom_loc]

      if File.exist?(EIF)
        puts "Pretty Eiffel already exists"
      else
        Dir.glob(eif_in + '/**/*.e').each do |name|
          eif_name = EIF + '/brie_doom/' + (name.delete_prefix(eif_in))

          result = `ec -pretty "#{name}"`

          raise "Could not prettify #{name}" if result.empty?

          FileUtils.mkdir_p(File.dirname(eif_name))

          File.write(eif_name, result)
        end
      end
    end

    desc 'Extract Eiffel functions stats'
    task funcs: :pretty do
      data = EifFunc.new(Dir.glob(EIF + '/**/*.e'))
      File.write(EIF_FUNCS, data.functions.to_json)
    end
  end

  desc 'Everything Eiffel-related'
  task eif: ['eif:funcs']

  desc 'Combine data'
  task :combine, [:doom_loc] => ['c', 'eif'] do
    c_loc = File.read(C_LOC).to_i
    c_funcs = JSON.parse(File.read(C_FUNCS))
    eif_funcs = JSON.parse(File.read(EIF_FUNCS))
    data = Combine.new(c_loc, c_funcs, eif_funcs).functions_ported
    yml = JSON.parse(JSON.dump(data)).to_yaml
    File.write(DATA_FUNCTIONS_PORTED, yml)
  end
end
