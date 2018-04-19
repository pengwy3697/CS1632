# Class VarHash
# A hash to keep track of variables defined to their values
class VarHash
  def initialize
    @var_value_pairs = {}
  end

  # Method put
  # puts a variable along with its value to hash
  def put(key, value)
    @var_value_pairs[key.upcase] = value
  end

  # Method get
  # gets a variable value by its name
  def get(element)
    element unless @var_value_pairs.key? element
    # element.match(/^[a-zA-Z]+/)
    @var_value_pairs[element.upcase]
  end

  # Method clear
  # clears up entire hash
  def clear
    @var_value_pairs = {}
  end

  # Method print
  # returns contents of hash as a string
  def print
    string = ''
    @var_value_pairs.keys.sort.each do |key|
      string += "#{key} #{@var_value_pairs[key]}\n"
    end
    string
  end
end
