require 'numo/gnuplot'

class BoxPlot
  def initialize(name:, out_dir:, out_type:)
    @name = name
    @out_dir = out_dir
    @out_type = out_type
  end

  def plot(plots)
    name = @name
    out_type = @out_type
    if out_type == 'cairolatex'
      ext = 'tex'
    else
      ext = out_type
    end

    out_path = "#{@out_dir}/#{@name}.#{ext}"
    Numo.gnuplot do
      terminal = {
        terminal: out_type
      }
      terminal[:name] = name.to_s if out_type == 'svg'
      set terminal

      if out_type == 'svg'
        set :title, name.to_s, :noenhanced
      end
      set out: out_path

      set xlabel: 'Cluster'
      set ylabel: 'Time (microseconds)'

      num_min = nil
      num_max = nil

      i = 0
      xts = []
      plots_data = plots.map do |t, vals|
        nums, times = vals.transpose

        fps = times.count.to_f / (times.sum.to_f / (10 ** 6))

        i += 1
        xts << "\"#{t}\" #{i}"
        [
          times,
          [i] * nums.count,
          using: [2, 1],
          w: :boxplot,
          t: "#{t}, average FPS = #{fps.round(2)}",
          pointsize: 0.1,
        ]
      end

      set :xtics, '(' + xts.join(', ') + ')'

      plot *plots_data
    end
  end
end
