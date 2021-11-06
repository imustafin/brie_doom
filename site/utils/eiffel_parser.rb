class EiffelParser
  def initialize(lines, cluster)
    @lines = lines
    @cluster = cluster
  end

  def depth(line)
    line.chars.take_while { |x| x == "\t" }.count
  end

  def parse_file
    global = parse_tree(@lines)

    features = global.filter { |(k, v)| k.start_with?('feature') }.flat_map(&:last)

    funcs_tree = parse_tree(features)

    funcs = funcs_tree.map { |f| make_func(f.first, f.last) }.compact

    class_name = global.find { |(k, v)| k.split.include?('class') }.last.first.split.first

    funcs.map { |f| { **f, class: class_name, cluster: @cluster } }
  end

  def make_func(signature, lines)
    name = signature.split.first.strip.chomp(':')

    return nil if lines.empty?

    blocks = parse_tree(lines).to_h

    return unless blocks['do']

    do_block = blocks['do']
    do_lines = do_block.count
    local_lines = (blocks['local'] || []).count

    stub = do_block.any? { |line| line.include?('NOT_IMPLEMENTED') }

    {
      ename: name,
      eloc: do_lines + local_lines,
      stub: stub
    }
  end

  def parse_tree(lines)
    ans = []

    cur_key = nil
    cur_lines = []

    lines.each do |line|
      next if line.strip.empty?
      next if line.strip.start_with?('--')

      tabs = depth(line)

      if tabs == 0
        if cur_key
          ans << [cur_key, cur_lines]
        end

        cur_key = line.strip
        cur_lines = []

        next
      end

      cur_lines << line[1..]
    end

    if cur_key
      ans << [cur_key, cur_lines]
    end

    ans
  end
end
