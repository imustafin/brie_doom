require_relative 'utils/perf/plot.rb'
require_relative 'utils/perf/plot_data.rb'
require 'fileutils'
require 'yaml'

task :performance_data do
  data = {}

  no_keeps = PlotData.new('no_contracts').data['level 1'].transpose.last
  keeps = PlotData.new('no_contracts_keep').data['level 1'].transpose.last
  alls = PlotData.new('all_contracts').data['level 1'].transpose.last

  no_keep_fps = no_keeps.count.to_f / no_keeps.sum * 1_000_000
  keep_fps = keeps.count.to_f / keeps.sum * 1_000_000
  all_fps = alls.count.to_f / alls.sum * 1_000_000

  data = {
    'no_keep_fps' => no_keep_fps.round.to_s,
    'keep_fps' => keep_fps.round.to_s,
    'all_fps' => all_fps.round(2).to_s,
    'no_keep_vs_keep_fps' => (no_keep_fps / keep_fps).round(2).to_s,
    'keep_vs_all_fps' => (keep_fps / all_fps).round(2).to_s
  }

  File.write('_data/perf.yml', data.to_yaml)
end

task :performance_plots do
  files = {
    no_contracts: PlotData.new('no_contracts').data,
    keep_vs_no_keep: {
      'No Keep' => PlotData.new('no_contracts').data['level 1'],
      'Keep' => PlotData.new('no_contracts_keep').data['level 1']
    },
    per_cluster: {
      'math' => PlotData.new('only_math').data['level 1'],
      'pointers' => PlotData.new('only_pointers').data['level 1'],
      'render' => PlotData.new('only_render').data['level 1'],
      'root' => PlotData.new('only_root').data['level 1'],
      'sound' => PlotData.new('only_sound').data['level 1'],
      'status bar' => PlotData.new('only_status_bar').data['level 1']
    },
    per_cluster2: {
      'pointers' => PlotData.new('only_pointers').data['level 1'],
      'root' => PlotData.new('only_root').data['level 1'],
      'sound' => PlotData.new('only_sound').data['level 1'],
      'status bar' => PlotData.new('only_status_bar').data['level 1']
    },
    all: {
      'No Keep' => PlotData.new('no_contracts').data['level 1'],
      'Keep, disable' => PlotData.new('no_contracts_keep').data['level 1'],
      'Keep, enable' => PlotData.new('all_contracts').data['level 1']
    }
  }

  out_dir = 'perf_plots/'
  FileUtils.mkdir_p out_dir

  files.each do |name, plots|
    p = Plot.new(name: name, out_dir: out_dir)
    p.plot(plots)
  end
end

task performance: %i[performance_data performance_plots] do

end
