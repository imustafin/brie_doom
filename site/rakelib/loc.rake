require 'json'
require 'rake/clean'

require_relative '../utils/c_loc'
require_relative '../utils/c_func'
require_relative '../utils/eif_func'

namespace :loc do
  TMP = 'tmp'
  CLOBBER.include(TMP)

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
        sh "cccc --lang=c --outdir=locs *.{c,h}"
        data = CLoc.new('locs/anonymous.xml')
        File.write('../c_loc', data.loc)
      end
    end

    desc 'Extract C functions stats'
    task funcs: :clone do |_t, args|
      Dir.chdir(DOOM) do
        sh "cccc --lang=c --outdir=funcs *.c"

        data = CFunc.new('funcs/anonymous.xml')
        File.write('../c_funcs.json', data.functions.to_json)
      end
    end
  end

  desc 'Everything C-Related'
  task c: ['c:loc', 'c:funcs']

  namespace :eif do
    EIF_IN = '../brie_doom'
    EIF = 'tmp/eif'


    desc 'Make prettified copies of Eiffel classes'
    task :pretty do
      if File.exist?(EIF)
        puts "Pretty Eiffel already exists"
      else
        Dir.glob(EIF_IN + '/**/*.e').each do |name|
          eif_name = EIF + (name.delete_prefix(EIF_IN))

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
      File.write(TMP + '/eif_funcs.json', data.functions.to_json)
    end
  end
end
