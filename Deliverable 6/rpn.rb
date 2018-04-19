require_relative 'rpn_batch'
require_relative 'rpn_repl'

# Main program starts here
# It runs in 2 modes: interactive REPL mode or batch mode
# It processes RPN expressions entered in REPL mode
# or processes file(s) passed over command line as batch mode
begin
  if ARGV.any?
    batch = RPNBatch.new
    batch.process
  else
    repl = RPNRepl.new
    repl.process
  end
rescue RPNError => e
  puts e.error_msg
  exit(e.error_code)
end
