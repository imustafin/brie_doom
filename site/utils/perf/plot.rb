require 'numo/gnuplot'

class Plot
  def initialize(name:, out_dir:)
    @name = name
    @out_dir = out_dir
  end


  def plot(plots)
    name = @name
    out_path = "#{@out_dir}/#{@name}.svg"
    Numo.gnuplot do
      set terminal: :svg
      set out: out_path

      set :title, name.to_s, :noenhanced
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
