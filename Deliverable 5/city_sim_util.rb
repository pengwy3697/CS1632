# It provides method to generate random numer and validation checks
require_relative 'static_data'

# Method validate_arg
# takes 1 input argument as seed and checks its validity
# SUCCESS CASES: return seed
def validate_arg(arg)
  raise RuntimeError if arg.length != 1
  input_arg = arg[0]
  return 0 if input_arg.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil?
  input_arg.to_i
end

# Method gen_random
# takes first input argument as seed and second argument as range
# also checks the validity of input seed if any
# SUCCESS CASES: return seed within the allowed range
def gen_random(seed_in = nil, range_in = nil)
  srand(seed_in) unless seed_in.nil?

  if range_in.nil?
    rand
  else
    rand(range_in)
  end
end

# Method gen_random_start_city
# Select one of the four cities
# SUCCESS CASES: return random start city
def gen_random_start_city
  random_index = rand(0..StaticData::FUN_CITY_LOCS.length - 1)
  StaticData::FUN_CITY_LOCS[random_index]
end

# Method gen_random_next_city
# takes 1 input argument for start city
# SUCCESS CASES: return next random city reachable from current city
def gen_random_next_city(from_city)
  random_index = rand(0..StaticData::CITY_MAP[from_city].length - 1)
  StaticData::CITY_MAP[from_city][random_index]
end
