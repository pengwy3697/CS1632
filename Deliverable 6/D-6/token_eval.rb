require_relative 'stack'
require_relative 'var_hash'

# Class TokenEvaluator
# It evaluates input line as tokens within one pass
class TokenEvaluator
  def initialize(var_hash, stack)
    @var_hash = var_hash
    @stack = stack
  end

  # Method eval
  # It evaluates input tokens, push intermeidate / final values onto stack
  # takes 3 input arguments: tokens, max number of tokens allowed on stack,
  #                          line number
  # SUCCESS CASE: last number on stack is the value to be returned
  def interpret(tokens, max_num_on_stack, line_num)
    done = false
    idx = 0
    until done
      done = process_token(tokens, idx, line_num)
      idx += 1
      done = true if idx >= tokens.length
    end
    check_stack(max_num_on_stack, line_num)
  rescue FloatDomainError
    raise RPNError.new(line_num, 5, 'Error with number ' + tokens[idx])
  end

  # Method process_token
  # It processes tokens pending on its type: numeric, var name, or operator
  # and pushes evaluated result to stack
  # It takes 3 input arguments: tokens, token index and line number
  # SUCCESS CASE: token value pushed onto stack
  # FAILURE CASE: raises 'Could not evaluate expression'
  def process_token(tokens, idx, line_num)
    if token_is_numeric(tokens[idx])
      push_to_stack(tokens, idx, line_num)
      return false
    elsif token_is_valid_var_name(tokens[idx])
      return process_var(tokens, idx, line_num)
    elsif RPNDef::OPERATOR.key? tokens[idx]
      return process_operator(tokens, idx, line_num)
    end
    raise RPNError.new(line_num, 5, 'Could not evaluate expression')
  end

  # Method process_var
  # It retrieves variable value from hash
  # SUCCESS CASE: variable value successfully retrieved and pushed onto stack
  # FAILURE CASE: raises 'Variable is not initialized'
  def process_var(tokens, idx, line_num)
    var_value = @var_hash.get(tokens[idx])
    if var_value.nil?
      raise RPNError.new(line_num, 1,
                         "Variable #{tokens[idx]} is not initialized")
    end
    @stack.push(var_value)
    false
  end

  # Method process_operator
  # It pops off two numbers from the stack, evaluates the binary operation,
  # then conntinue with rest of the token array
  # SUCCESS CASE: RPN expression evaluated
  # FAILURE CASE: binary operator needs 2 operands. If there are less than 2
  #               operands on stack,, raise 'Operator applied to empty stack'
  def process_operator(tokens, idx, line_num)
    check_empty_stack(tokens, idx, line_num)
    var2 = @stack.pop
    var1 = @stack.pop
    result = eval_binary(var1, var2, tokens[idx], line_num)
    @stack.push(result)
    interpret(tokens.drop(idx + 1), 1, line_num) if tokens.length > idx + 1
    result
  end

  # Method check_empty_stack
  # It checks if stack is empty
  def check_empty_stack(tokens, idx, line_num)
    raise RPNError.new(line_num, 2,
                       "Operator #{tokens[idx]} " \
                       'applied to empty stack') if @stack.size < 2
  end

  # Method check_stack
  # It checks number of elements on stack
  # SUCCESS CASE: return and resume program
  # FAILURE CASE: raises 'x elements in stack after evaluation")
  def check_stack(max_num_on_stack, line_num)
    return if @stack.size <= max_num_on_stack
    raise RPNError.new(line_num, 3,
                       "#{@stack.size} elements in stack after evaluation")
  end

  # Method eval_binary
  # If operator is defined, evaluates the operation
  # It takes 3 input arguments: variable 1, variable 2 and an operator
  def eval_binary(var1, var2, oper, line_num)
    check_division_by_zero(var2, oper, line_num)
    unless RPNDef::OPERATOR[oper]
      raise RPNError.new(line_num, 5,
                         'Un-recognized Operator ' +
                         oper)
    end
    return var1 + var2 if oper == '+'
    return var1 - var2 if oper == '-'
    return var1 * var2 if oper == '*'
    return var1 / var2 if oper == '/'
  end

  def push_to_stack(tokens, idx, line_num)
    @stack.push(token_to_int(tokens[idx])) if token_is_integer(tokens[idx],
                                                               line_num)
  end

  # Method check_division_by_zero
  # It checks if operator is '/' and denominator is 0
  def check_division_by_zero(var2, oper, line_num)
    raise RPNError.new(line_num, 5, 'Division by ' \
                       'zero') if oper == '/' && var2.zero?
  end

  # Method token_is_integer
  # It checks if input token is an integer
  def token_is_integer(token, line_num)
    num = Float(token)
    return token if (num.to_f - num.to_i).zero?
    raise RPNError.new(line_num, 5, 'Sorry, does not allow decimal')
  end
end
