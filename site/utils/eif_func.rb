require 'eiffel_parser'

class EifFunc
  # Hash { c_name => [func] }
  attr_reader :functions

  def initialize(filenames)
    @functions = {}
    filenames.each { |name| parse_file(name) }
  end

  def parse_file(filename)
    lines = File.readlines(filename)
    cls = EiffelParser::Class.new(lines)

    cls.features.each do |feature|
      name = feature.name

      c_doom = nil
      if feature.note_clause
        # check all notes are known
        known = ['c_doom', "source", "testing"]
        unknown = feature.note_clause.keys - known
        raise "Unknown clauses #{unknown}" unless unknown.empty?

        c_doom = feature.note_clause['c_doom']&.gsub!(/"/, '')
      end

      key = (c_doom || name).downcase

      @functions[key] ||= []
      name = feature.name
      loc = %i[require_clause local_clause body ensure_clause]
        .map { |x| feature.send(x) }
        .compact
        .map(&:count)
        .sum + 1

      @functions[key] << {
        name: feature.name,
        loc: loc
      }
    end
  end
end
