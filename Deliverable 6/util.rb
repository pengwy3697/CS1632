# Method to determine if a given token is numeric
def token_is_numeric(token)
  Float(token)
rescue StandardError
  false
end

# Method to determine if a variable name is alphanumeric and
# has only a single char
def token_is_valid_var_name(string)
  string.length == 1 && token_is_alpha(string)
end

# Method to determine if input token is longer than 1 char
def token_longer_than_1_char(string)
  string.length > 1 && token_is_alpha(string)
end

# Method to determine if input token is alphanumeric
def token_is_alpha(string)
  !string.match(/\A[a-zA-Z]*\z/).nil?
end

# Method to check extension of input file
def rpn_file_extension(string)
  !string.match(/\.(rpn)$/i).nil?
end

# Method to convert a given numeric in string form
# into an integer
def token_to_int(string)
  # return string.to_f if string.include?('.')
  return string.to_f.to_i if string.include?('e')
  string.to_i
end
