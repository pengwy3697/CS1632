require_relative 'line_parser'
require_relative 'var_hash'

# Class RPNBatch
# The program enters into Batch mode
# and processes input file(s) as one concatenated file by
# utilizing Ruby's ARGF stream
class RPNBatch
  attr_reader :var_hash

  def initialize
    @var_hash = VarHash.new
  end

  # Method process
  # It reads each line from input file(s) and traps exceptions
  # SUCCESS CASE: each line processed
  # FAILURE CASE: prints out message and exit with error code
  def process
    check_and_skip_empty_files
    return true if ARGV.length.zero?
    process_argf
  end

  # Method skip_empty_files
  # It verifies each input file is not empty and with correct
  # .prn extension
  # SUCCESS CASE: remove empty files from ARGV
  def check_and_skip_empty_files
    empty_files = []
    ARGV.each do |file_name|
      check_each_file(file_name)
      empty_files.push(file_name) if File.zero?(file_name)
    end
    ARGV.replace ARGV - empty_files
  end

  # Method check_each_file
  # It chehcks each file has extension .rpn and does exist
  # SUCCESS CASE: each file checked
  def check_each_file(file_name)
    unless rpn_file_extension(file_name)
      raise RPNError.new(1, 5,
                         "Not with .rpn exptension: #{file_name}")
    end
    return if File.exist?(file_name)
    raise RPNError.new(1, 5, 'Input file not found: ' + file_name)
  end

  # Method process_argf
  # It loops through each line from input file(s) and skips over empty lines
  # SUCCESS CASE: each line processed
  def process_argf
    ARGF.each_line do |line|
      each_line(line)
    end
    true
  end

  # Method each_line
  # It invokes line parser to process each line
  # SUCCESS CASE: returns result of interpretation
  def each_line(line, test_mode = false)
    return nil if line.strip.empty?
    return LineParser.new(@var_hash).parse(ARGF.lineno, line) unless test_mode
    LineParser.new(@var_hash).parse(1, line)
  end
end
