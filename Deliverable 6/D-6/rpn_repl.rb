require_relative 'line_parser'
require_relative 'var_hash'
require_relative 'util'
require_relative 'rpn_error'
require_relative 'rpn_def'

# Class RPNRepl
# The program enters into REPL mode and reads RPM
# expression from command line one line at a time
class RPNRepl
  def initialize(test_mode = false)
    @var_hash = VarHash.new
    @test_mode = test_mode
  end

  # Method process
  # It reads input from command line until 'QUIT' is entered
  # or user confirmed Control-C interrupt by 'Y'
  # SUCCESS CASE: each line processed
  def process
    done = false
    done = input_handler until done
  end

  # Method input_handler
  # It reads from stdin
  # SUCCESS CASE: each line processed
  # FAILURE CASE: User invokes Control-C or RPN expression has error(s)
  def input_handler(test_cmd = nil)
    read_stdin(test_cmd)
  rescue Interrupt
    exit_confirmation
  rescue RPNError => e
    puts e.error_msg
  rescue NoMethodError
    false
  end

  # Method read_stdin
  # It prints out prompt and gets user input
  # SUCCESS CASE: each line processed by parser
  # FAILURE CASE: line could be empty. In such case, return false
  #               and continue REPL
  def read_stdin(test_cmd = nil)
    print RPNDef::PROMPT unless @test_mode
    line = get_line(test_cmd)
    return false if line.nil?
    tokens = line.chomp.split
    return true if tokens[0].casecmp('QUIT').zero?
    return LineParser.new(@var_hash, false).parse(2, line.chomp) if @test_mode
    output = LineParser.new(@var_hash, false).parse(ARGF.lineno, line.chomp)
    puts output unless output.nil?
  end

  # Method exit_confirmation
  # If interrupt is detected, ask for user confirmation if exit or not
  # SUCCESS CASE: Y or N is entered by user
  # FAILURE CASE: repeated Control-C is entered
  def exit_confirmation(test_cmd = nil)
    done = false
    print 'Do you really want to exit? [Y|N] '
    yes_or_no = get_line(test_cmd)
    return false if yes_or_no.nil?
    done = true if yes_or_no.chomp.casecmp('Y').zero?
    done
  rescue Interrupt
    print "\n"
  end

  # Method get_line
  # Either gets an user input or return test command while in test mode
  def get_line(test_cmd = nil)
    return gets if test_cmd.nil?
    @test_mode = true
    test_cmd
  end
end
