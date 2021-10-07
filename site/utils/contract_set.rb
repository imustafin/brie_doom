# Control which contracts are enabled per-cluster
# Give the path to an .ecf, the results will be printed to that .ecf
require 'nokogiri'

class Ecf
  TARGET = 'sdl-eiffel-doom'

  def initialize(doc)
    @doc = doc
  end

  def target
    @doc.css("target[name = \"#{TARGET}\"]").first
  end

  def root_cluster
    target.xpath("./xmlns:cluster").first
  end

  def set_assertions_deep(node, contracts)
    [node, *all_subclusters(node)].each do |n|
      set_assertions(n, contracts)
    end
  end

  def set_assertions(node, contracts)
    option = node.xpath('./xmlns:option').first
    unless option
      option = node.add_child('<option>').first
    end

    assertions = option.xpath('./xmlns:assertions').first
    unless assertions
      assertions = option.add_child('<assertions>').first
    end

    contracts.each do |k, v|
      assertions[k.to_s] = v.to_s
    end
  end

  def direct_subclusters(node)
    node.xpath('./xmlns:cluster')
  end

  def all_subclusters(node)
    node.xpath('xmlns:cluster')
  end

  def direct_subcluster_names(node)
    direct_subclusters(node).map { |x| x['name'] }
  end

  def subcluster(name)
    root_cluster.css("cluster[name = \"#{name}\"]").first
  end

  def to_xml
    @doc.to_xml
  end

  # plan: { k: assertions }
  # where k is subcluster or 'root'
  # assertions is hash { precondition: bool, ...}
  def set_plan(plan)
    plan.each do |k, assertions|
      if k.to_s == 'root'
        set_assertions(root_cluster, assertions)
      else
        set_assertions_deep(subcluster(k), assertions)
      end
    end
  end
end

def all_contracts
  {
    precondition: true,
    postcondition: true,
    check: true,
    invariant: true,
    loop: true,
    supplier_precondition: true
  }
end

def no_contracts
  {
    precondition: false,
    postcondition: false,
    check: false,
    invariant: false,
    loop: false,
    supplier_precondition: false
  }
end

def only_supplier
  no_contracts.merge(
    supplier_precondition: true
  )
end

def no_invariants
  all_contracts.merge(
    invariant: false
  )
end

if $0 == __FILE__
  filename = ARGV.first
  doc = File.open(filename) { |f| Nokogiri::XML(f) }
  ecf = Ecf.new(doc)

  subclusters = ecf.direct_subclusters(ecf.root_cluster)
  subclusters = subclusters.map do |sub|
    [sub['name'], ecf.all_subclusters(sub).map { |x| x['name'] }]
  end

  pp subclusters

  sound = ecf.subcluster('sound')
  ecf.set_assertions(sound, no_contracts)

  File.write('no.ecf', ecf.to_xml)

  ecf.set_assertions(sound, all_contracts)

  File.write('all.ecf', ecf.to_xml)
end

