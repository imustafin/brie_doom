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
subclusters -= ['tests', 'wad']

# Put no_contracts_keep
begin
  plan_name = :no_contracts_keep
  subs = {}
  subclusters.each do |s|
    subs[s] = no_contracts
  end

  plans[plan_name] = subs
end

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

# # Put and 2-combinations
# (subclusters).combination(2).each do |(a, b)|
#   plan_name = (a + '_and_' + b).to_sym
#   subs = {}
#   subclusters.each do |s|
#     subs[s] = no_contracts
#   end
#   subs[a] = all_contracts
#   subs[b] = all_contracts
#   subs['root'] = all_contracts

#   plans[plan_name] = subs
# end

# Put all contracts plan
plans[:all_contracts] = {}
subclusters.each do |sub|
  plans[:all_contracts][sub] = all_contracts
end

plans = plans.slice(:no_contracts, :no_contracts_keep)

plans.each do |plan, contracts|
  Dir.chdir(ROOT)

  plan = ("ded_" + plan.to_s).to_sym

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

  compile = "ec -finalize #{keep} -config #{plan_ecf_filename} -c_compile"
  res = system(compile)

  # exit(1) unless res
  # p compile

  system("time ./EIFGENs/sdl-eiffel-doom/F_code/brie_doom -timedemo demo1 > timedemo_result_#{plan.to_s}.out 2> timedemo_result_#{plan.to_s}.err")
end

Dir.chdir(ROOT)
