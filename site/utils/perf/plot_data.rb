class PlotData
  GS_MAP = {
    'wipe' => 'wipe',
    'gamestate 0' => 'level',
    'gamestate 1' => 'intermission',
    'gamestate 2' => 'finale',
    'gamestate 3' => 'demoscreen'
  }

  attr_reader :data

  def initialize(in_file)
    full_name = File.join(__dir__, "result_data/timedemo_result_#{in_file}.out")
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

    gs_cnt = Hash.new(1)
    cur_gs = nil
    cur_ar = nil
    @data = {}

    lines.each do |d|
      if cur_gs != d.last
        cur_ar = []
        t = "#{d.last} #{gs_cnt[d.last]}"
        @data[t] = cur_ar

        gs_cnt[cur_gs] += 1

        cur_gs = d.last
      end


      cur_ar << [d[0], d[1]]
    end
  end
end
