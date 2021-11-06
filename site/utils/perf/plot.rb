require 'numo/gnuplot'

class Plot
  def initialize(name:, out_dir:)
    @name = name
    @out_dir = out_dir
  end

  GS_MAP = {
    'wipe' => 'wipe',
    'gamestate 0' => 'level',
    'gamestate 1' => 'intermission',
    'gamestate 2' => 'finale',
    'gamestate 3' => 'demoscreen'
  }

  def read_data
    full_name = File.join(__dir__, "result_data/timedemo_result_#{@name}.out")
    lines = []

    File.open(full_name) do |file|
      file.each_line.with_index do |line, num|
        line.strip!

        next unless line.match? /\d+,.+/

        time, gamestate = line.split(',')
        time = time.to_i

        lines << [num, time, GS_MAP.fetch(gamestate)]
      end
    end

    lines
  end

  def plot
    data = read_data

    last_gs = nil
    sections = []

    gs_cnt = Hash.new(1)

    data.each do |d|
      if last_gs != d.last
        sections << []

        gs_cnt[last_gs] += 1

        last_gs = d.last
      end

      t = "#{d.last} #{gs_cnt[d.last]}"

      sections.last << [d[0], d[1], t]
    end

    out_path = "#{@out_dir}/#{@name}.svg"
    Numo.gnuplot do
      set :title, @name, :noenhanced
      set xlabel: 'Frame'
      set ylabel: 'Time (microseconds)'

      plots = sections.map do |d|
        nums, times, gss = d.transpose
        t = gss.first
        [nums, times, w: 'lines', t: t]
      end

      plot *plots

      output out_path
    end
  end
end
