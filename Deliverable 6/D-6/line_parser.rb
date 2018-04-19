require_relative 'rpn_def'
require_relative 'stack'
require_relative 'var_hash'
require_relative 'token_eval'
require_relative 'util'

# Class LineParser
# It parses and interprets one line at a time
class LineParser
  def initialize(hash_in, batch_mode = true)
    @var_hash = hash_in
    @batch_mode = batch_mode
    @stack = Stack.new
    @token_evaluator = TokenEvaluator.new(@var_hash, @stack)
    @line_num = 1
  end

  # Method parse
  # takes 2 input arguments: line number and input line
  # SUCCESS CASE: last number on stack is the value to be returned
  def parse(line_num, line)
    tokens = line.split
    @stack.clear
    @line_num = line_num
    process_tokens(tokens)
    return @stack.pop.to_s if @stack.size >= 1
  end

  # Method process_tokens
  # token can be a keyword, variable, numeric or RPN expression
  def process_tokens(tokens)
    if token_longer_than_1_char(tokens[0])
      exit(0) if tokens[0].casecmp('QUIT').zero?
      process_keyword(tokens)
    else
      interpret_token(tokens)
    end
  end

  # Method process_keyword
  # It validates if token is one of the defined keywords
  # SUCCESS CASE: peforms appropriate logic based on keywords
  # FAILURE CASE: raises 'Unknown keyword' exception
  def process_keyword(tokens)
    return process_let(tokens) if tokens[0].casecmp('LET').zero?
    return process_print(tokens) if tokens[0].casecmp('PRINT').zero?
    raise RPNError.new(@line_num, 4, 'Unknown keyword ' + tokens[0])
  end

  # Method interpret_token
  # It evaluates token which could be a variable defined or a number
  # SUCCESS CASE: receives variable value from hash or token is already numeric
  # FAILURE CASE: raises 'Cannot process line' exception
  def interpret_token(tokens)
    if token_is_valid_var_name(tokens[0])
      @token_evaluator.interpret(tokens, 1, @line_num)
    elsif token_is_numeric(tokens[0])
      @token_evaluator.interpret(tokens, 1, @line_num)
    else
      raise RPNError.new(@line_num, 5, 'Cannot process line')
    end
    # puts @stack.print
    @stack.pop if @batch_mode
  end

  # Method process_let
  # It evaluates variable and resolve it to a numeric value
  # SUCCESS CASE: stores variable value in hash
  def process_let(tokens)
    check_let_syntax(tokens)
    @token_evaluator.interpret(tokens.drop(2), 1, @line_num)
    @var_hash.put(tokens[1], @stack.peek(-1)) if @stack.size == 1
    @stack.pop if @batch_mode
  end

  # Method check_let_syntax
  # It checks the grammar of let statement
  # SUCCESS CASE: let statement syntatically checked
  # FAILURE CASE: raises appropriate exceptions as per requirement
  def check_let_syntax(tokens)
    if tokens.length == 1
      raise RPNError.new(@line_num, 5, 'No variable name defined')
    end
    unless token_is_valid_var_name(tokens[1])
      raise RPNError.new(@line_num, 5,
                         "Variable should be a single letter: #{tokens[1]}")
    end
    return unless tokens.length == 2
    raise RPNError.new(@line_num, 2, 'Operator LET ' \
                       'applied to empty stack')
  end

  # Method process_print
  # It evaluates rpn expression following PRINT
  # SUCCESS CASE: outputs value
  # FAILURE CASE: raises exceptions when 'No argument given'
  def process_print(tokens)
    raise RPNError.new(@line_num, 5, 'No argument given') if tokens.length == 1
    @token_evaluator.interpret(tokens.drop(1), 2, @line_num)
    puts @stack.peek(-1).to_s if @batch_mode
  end
end
