require 'json'
require 'rake/clean'

require_relative '../utils/c_loc'
require_relative '../utils/c_func'

namespace :loc do
  namespace :c do
    TMP = 'tmp'
    DOOM = TMP + '/DOOM/linuxdoom-1.10'

    CLOBBER.include(TMP)

    task :tmp_dir do
      FileUtils.mkdir_p(TMP)
    end

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
end
