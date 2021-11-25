require 'numo/gnuplot'

class Plot
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
      set terminal: out_type
      if out_type != 'cairolatex'
        set name: name.to_s
        set :title, name.to_s, :noenhanced
      end
      set out: out_path


      set xlabel: 'Frame'
      set ylabel: 'Time (microseconds)'

      num_min = nil
      num_max = nil

      plots = plots.map do |t, vals|
        nums, times = vals.transpose

        num_min = [*nums, num_min].compact.min
        num_max = [*nums, num_max].compact.max

        [nums, times, w: 'lines', t: t.to_s]
      end

      ref_35_fps = 1.0 / 35.0 * (10 ** 6)
      plots << [
        [num_min, num_max],
        [ref_35_fps, ref_35_fps],
        w: 'lines',
        t: '35 FPS reference',
        lc_rgb: 'red'
      ]

      plot *plots
    end
  end
end
