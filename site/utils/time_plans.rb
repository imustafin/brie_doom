# Time demo for different contract plans
require_relative 'contract_set'

ROOT = Dir.pwd

PRE = '../../brie_doom/'
ECF = 'brie_doom.ecf'


# Make plans
def new_ecf
  doc = File.open(PRE + ECF) { |f| Nokogiri::XML(f) }

  Ecf.new(doc)
end

plans = {
  no_contracts: nil,
}

ecf = new_ecf

subclusters = ecf.direct_subclusters(ecf.root_cluster).map { |x| x['name'] } + ['root']
subclusters -= ['tests']

# Put only_* plans
subclusters.each do |sub|
  plan_name = ('only_' + sub).to_sym
  subs = {}
  subclusters.each do |s|
    subs[s] = no_contracts
  end
  subs[sub] = all_contracts

  plans[plan_name] = subs
end

# Put root and 2-combinations
(subclusters - ['root']).combination(2).each do |(a, b)|
  plan_name = ('root_with_' + a + '_and_' + b).to_sym
  subs = {}
  subclusters.each do |s|
    subs[s] = no_contracts
  end
  subs[a] = all_contracts
  subs[b] = all_contracts
  subs['root'] = all_contracts

  plans[plan_name] = subs
end

# Put all contracts plan
plans[:all_contracts] = {}
subclusters.each do |sub|
  plans[:all_contracts][sub] = all_contracts
end

results = []

plans.each do |plan, contracts|
  Dir.chdir(ROOT)

  puts "==" * 8
  puts plan
  puts "==" * 8

  ecf = new_ecf

  if contracts
    ecf.set_plan(contracts)
    plan_ecf_filename = plan.to_s + '.ecf'
    File.write(PRE + plan_ecf_filename, ecf.to_xml)
    keep = '-keep'
  else
    plan_ecf_filename = ECF
    keep = ''
  end

  Dir.chdir(PRE)

  res = system("ec -finalize #{keep} -config #{plan_ecf_filename} -c_compile")

  exit(1) unless res

  system("./EIFGENs/sdl-eiffel-doom/F_code/brie_doom -timedemo demo1 > result_#{plan.to_s}.out 2> result_#{plan.to_s}.err")
end

Dir.chdir(ROOT)

File.write('report.txt', results.join("\n"))
