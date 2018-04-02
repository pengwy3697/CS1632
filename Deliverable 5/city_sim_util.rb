# Class CitySimUtil
# It provides method to generate random numer and validation checks

def validate_arg(arg)
  # :nocov:
  raise RuntimeError if arg.length != 1
  input_arg = arg[0]
  # is_valid = input_arg.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/)
  return 0 if input_arg.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil?
  input_arg.to_i
  # :nocov:
end
