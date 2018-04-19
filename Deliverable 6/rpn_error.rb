# Class RPNError
# This class inherits from RuntimeError
# and stores customized error code and error message
class RPNError < RuntimeError
  attr_reader :error_code
  attr_reader :error_msg

  def initialize(line_num, error_code, error_msg)
    super(error_msg)
    @error_code = error_code
    @error_msg = "Line #{line_num}: #{error_msg}"
  end
end
