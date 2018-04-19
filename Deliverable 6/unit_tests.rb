require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require_relative 'rpn_batch'
require_relative 'rpn_repl'
require_relative 'var_hash'
require_relative 'line_parser'
require_relative 'rpn_error'
require_relative 'util'

# Class RPNUnitTest
# It provides unit test methods for RPN++
class RPNUnitTest < MiniTest::Test
  def setup
    @batch = RPNBatch.new
    @repl = RPNRepl.new(true)
    @var_hash = VarHash.new
    @stack = Stack.new
    @parser = LineParser.new(@var_hash, false)
    @token_eval = TokenEvaluator.new(@var_hash, @stack)
  end

  # TC 1
  # This unit test checks the program can be run on command line
  # using 'ruby rpn.rb'
  # BASE CASE
  def test_run_ruby_rpn_rb
    tempfile = Tempfile.new(['temp', '.rpn'], '.')
    tempfile.write('PRINT 1\nQUIT')
    ARGV.replace [tempfile.path]

    # Simulate invoking 'ruby rpn.rb tempfile.rpn'
    assert system("ruby rpn.rb #{tempfile.path}")
    tempfile.close
    tempfile.unlink
  end

  # TC 2
  # This unit test checks tokens can be numbers
  # BASE CASE
  def test_token_is_number
    tokens = %w[100 1.2E4 8_000 -42 -0]
    tokens.each do |token|
      assert token_is_numeric(token)
    end
  end

  # UNIT TESTS FOR KEYWORDS
  # Equivalence classes:
  # keywords are valid      -> keywords identified
  # keywords are invalid    -> exception raised

  # TC 3
  # This unit test checks tokens can be one of the keywords
  # QUIT, LET, or PRINT and case-insensitive
  def test_token_is_keyword
    keywords = %w[LET PRINT QUIT let print quit lEt pRint Quit]
    keywords.each do |word|
      assert_includes RPNDef::KEYWORD, word.upcase
    end
  end

  # TC 21
  # This unit test checks when keyword is invalid, the program informs
  # the user and QUIT the program with error code 4.
  def test_token_is_unknown_keyword
    lines = %w[BUMBLEBEE YEY QUITT]
    line_num = 1
    lines.each do |line|
      begin
        @parser.parse(line_num, line)
      rescue RPNError => e
        assert_equal 4, e.error_code
        assert_equal "Line #{line_num}: Unknown keyword #{lines[line_num - 1]}",
                     e.error_msg
        line_num += 1
      end
    end
  end

  # TC 4
  # This unit test checks tokens can be one of the +, -, /, or *
  # BASE CASE
  def test_is_operator
    operators = ['+', '-', '*', '/']
    operators.each do |op|
      assert RPNDef::OPERATOR[op]
    end
  end

  # TC 5
  # This unit test checks that numbers can be arbitrary
  # precisions and stored as such
  # BASE CASE
  def test_number_has_arbitrary_precisions
    variables = %w[A B C]
    numbers = %w[1_000_000 9e3 -2000]
    expected_result = %w[1000000 9000 -2000]
    lines = ["LET A #{numbers[0]}", "LET B #{numbers[1]}",
             "LET C #{numbers[2]}"]
    idx = 0
    lines.each do |line|
      @parser.parse(1, line)
      var_str = @var_hash.get(variables[idx]).to_s
      assert_equal expected_result[idx], var_str
      idx += 1
    end
  end

  # TC 6
  # This unit test checks variables shall be
  # a single letter (A-Z) and are case-insensitive
  # BASE CASE
  def test_valid_variable_names
    tokens = %w[A B a b]
    tokens.each do |token|
      assert token_is_valid_var_name(token)
    end
  end

  # UNIT TESTS FOR ALLOWED OPERATORS
  # Equivalence classes:
  # +, -, *, /         -> binary operations evaluated
  # undefined operator -> exception raised

  # TC 7
  # This unit test checks that Operators can be +, -, /, or *,
  # for add, subtract, divide, and multiply
  def test_operator_is_add_subtract_divide_multiply
    expected_result = [3.5, -0.5, 3.0, 0.75]
    operators = ['+', '-', '*', '/']
    idx = 0
    operators.each do |operator|
      begin
        output = @token_eval.eval_binary(1.5, 2, operator, 1)
        assert_equal expected_result[idx], output
        idx += 1
      end
    end
  end

  # TC 43
  # This unit test checks that Operators are not +, -, /, or *,
  def test_operator_not_add_subtract_divide_multiply
    operators = ['^', '%']
    idx = 0
    operators.each do |operator|
      begin
        @token_eval.eval_binary(1, 2, operator, 1)
      rescue RPNError => e
        assert_equal 5, e.error_code
        assert_equal 'Line 1: Un-recognized Operator ' +
                     operators[idx], e.error_msg
        idx += 1
      end
    end
  end

  # TC 8
  # This unit test checks the keyword QUIT causes the
  # program to end.
  # BASE CASE
  def test_quit
    line = 'QUIT'
    assert_raises(SystemExit) { @parser.parse(1, line) }
  end

  # TC 9
  # This unit test checks any lines or tokens after the QUIT
  # keyword are ignored
  # BASE CASE
  def test_ignore_tokens_after_quit
    lines = ['QUIT PRINT 1', "quit\nPrint 200 LET A\n"]
    lines.each do |line|
      assert_raises(SystemExit) { @parser.parse(1, line) }
    end
  end

  # UNIT TESTS FOR KEYWORD LET
  # Equivalence classes:
  # variables initialized properly    -> variables are stored in hash
  # variables incorrectly initialized -> variables not persisted
  # invalid let syntax                -> exceptions

  # TC 10
  # Let initializes Variable names, case insensitive
  def test_let_initializes_variables_regardless_case
    lines = ['LET A 4 5 +', 'LET B 1 2 *']
    lines.each do |line|
      @batch.each_line(line)
    end
    assert_equal 9, @batch.var_hash.get('A')
    assert_equal 9, @batch.var_hash.get('a')
    assert_equal 2, @batch.var_hash.get('B')
    assert_equal 2, @batch.var_hash.get('b')
  end

  # TC 20
  # let not initializes variables correctly, variables not initialized.
  # Program to quit with error code 1 along with proper message
  def test_let_with_uninitialized_var
    line = 'LET A'
    @batch.each_line(line, true)
  rescue RPNError => e
    assert_equal 2, e.error_code
    assert_equal 'Line 1: Operator LET applied to empty stack', e.error_msg
    assert_nil @batch.var_hash.get('A')
    assert_nil @batch.var_hash.get('a')
  end

  # TC 34
  # Various invalid syntax of LET will be properly caught
  # and the variables will not be defined
  def test_let_with_invalid_syntax
    lines = ['LET', 'LET A 1 2', 'LET Bb 2']
    expected_result = ['No variable name defined',
                       '2 elements in stack after evaluation',
                       'Variable should be a single letter: Bb']
    idx = 0
    lines.each do |line|
      begin
        @parser.parse(1, line)
      rescue RPNError => e
        assert_equal "Line 1: #{expected_result[idx]}", e.error_msg
        idx += 1
      end
    end
    assert_nil @var_hash.get('A')
    assert_nil @var_hash.get('bb')
  end

  # UNIT TESTS FOR KEYWORD PRINT
  # Equivalence classes:
  # batch mode print successfully -> value printed
  # repl mode print successfully -> value printed
  # print failed                  -> exception raised

  # TC 11
  # This unit test checks in batch mode, PRINT outputs the result
  # of the RPN expression
  def test_batch_mode_print
    assert_equal '3', @batch.each_line('PRINT 1 2 +')
  end

  # TC 49
  # This unit test checks in repl mode, PRINT outputs the result
  # of the RPN expression
  def test_repl_mode_print
    assert_equal '3', @repl.input_handler('PRINT 1 2 +')
  end

  # TC 14
  # This unit test checks when PRINT refers to an uninitialized variable
  # will cause the program with error code 1 with 'Variable x is not
  # initialized'
  def test_print_with_uninitialized_var
    line = 'PRINT A'
    @parser.parse(1, line)
  rescue RPNError => e
    assert_equal 1, e.error_code
    assert_equal 'Line 1: Variable A is not initialized', e.error_msg
  end

  # TC 12
  # This unit test checks if keywords are not at start of line
  # program will exit with error code 5 along with proper message
  # EDGE CASE
  def test_keyword_should_be_at_start_of_line
    lines = ['31 2 + PRINT 3', '99 1 + LET 3', '2 QUIT']
    lines.each do |line|
      begin
        @parser.parse(1, line)
      rescue RuntimeError => e
        assert_equal 5, e.error_code
        assert_equal 'Line 1: Could not evaluate expression', e.error_msg
      end
    end
  end

  # TC 13
  # This unit test checks that Variables shall be considered
  # initialized once they have been LET, regardless of case
  # BASE CASE
  def test_batch_mode_initialized_var
    @batch.each_line('LET X 2')
    assert_equal 2, @batch.var_hash.get('X')
    assert_equal 2, @batch.var_hash.get('x')
    assert_nil @batch.var_hash.get('Y')
  end

  # TC 15
  # his unit test checks that in REPL mode, user will be informed about
  # Uninitialized variables
  # EDGE CASE
  def test_repl_mode_uninitialized_var_will_not_quit_program
    assert_output ("Line 2: Variable A is not initialized\n") { @repl.input_handler('PRINT A') }
  end

  # TC 16
  # This unit test checks when stack is empty and does not contain
  # enough operands for operator, program will exit with
  # error code is 2 along with proper message
  # EDGE CASE
  def test_operator_applied_to_empty_stack
    lines = ['1 2 + +', '6 -', '9 *', '8 8 8 / / /']
    operators = ['+', '-', '*', '/']
    idx = 0
    lines.each do |line|
      begin
        @parser.parse(1, line)
      rescue RuntimeError => e
        assert_equal 2, e.error_code
        assert_equal 'Line 1: Operator ' \
                     "#{operators[idx]} applied to empty stack", e.error_msg
        idx += 1
      end
    end
  end

  # TC 17
  # his unit test checks that in REPL mode, user will be informed about
  # empty stack 'Operator applied to empty stack'
  # EDGE CASE
  def test_repl_mode_empty_stack_will_not_quit_program
    assert_output ("Line 2: Operator + applied to empty stack\n") { @repl.input_handler('1 2 + +') }
  end

  # TC 18
  # This unit test checks when line contains more than one
  # element and the line has been evaluated,
  # program exits with error code 3 along with proper message
  # EDGE CASE
  def test_too_many_elements_on_stack
    lines = ['1 2 3', '6 6 - 1', '9 9 - 3 3 + 7 8 0']
    cnt = %w[3 2 5]
    idx = 0
    lines.each do |line|
      begin
        @parser.parse(1, line)
      rescue RuntimeError => e
        assert_equal 3, e.error_code
        assert_equal 'Line 1: ' + cnt[idx] + ' elements in stack ' \
                     'after evaluation', e.error_msg
        idx += 1
      end
    end
  end

  # TC 19
  # his unit test checks that in REPL mode, user will be informed about
  # too many elements on stack
  # EDGE CASE
  def test_repl_mode_too_many_elements_will_not_quit_program
    assert_output ("Line 2: 3 elements in stack after evaluation\n") { @repl.input_handler('1 2 3') }
  end

  # TC 22
  # his unit test checks that in REPL mode, user will be informed about
  # unknown keyword
  # EDGE CASE
  def test_repl_mode_unknown_keyword_will_not_quit_program
    assert_output ("Line 2: Unknown keyword BUMBLEBEE\n") { @repl.input_handler('BUMBLEBEE') }
  end

  # TC 23
  # This unit test checks that all other errors shall result in
  # the program informing the user of the error and exiting with
  # error code 5
  # EDGE CASE
  def test_arbitrary_string
    lines = ['EVERYONE_GETS_A', 'YEY! SUMMER IS HERE']
    lines.each do |line|
      begin
        @parser.parse(1, line)
      rescue RPNError => e
        assert_equal 5, e.error_code
        assert_equal 'Line 1: Cannot process line', e.error_msg
      end
    end
  end

  # TC 24
  # This unit test checks that in REPL mode, rpn expression is properly
  # evaluated
  # BASE CASE
  def test_repl_mode_rpn_evaluation
    @repl.read_stdin('1 2 +')
    # assert_match /3\n/, RPNRepl.new.input_handler('PRINT 1 2 +')
    assert_equal '3', @repl.input_handler('PRINT 1 2 +')
  end

  # TC 25
  # This unit test checks that in REPL mode, PRINT shall not perform
  # any additional work
  # BASE CASE
  def test_repl_mode_print_rpn_evaluation
    @repl.read_stdin('PRINT 1 2 +')
    assert_equal '3', @repl.input_handler('PRINT 1 2 +')
  end

  # TC 26
  # This unit test checks that Lines in files are considered to be 1-indexed
  # BASE CASE
  def test_lines_files_are_one_indexed
    # Create a temp file with 3 lines, expecting exception to be raised
    # at line number 3
    tempfile = Tempfile.new(['temp', '.rpn'], '.')
    tempfile.write('LET A 1')
    tempfile.write('LET B 2')
    tempfile.write('PRINT 1 2 3')
    tempfile.close
    ARGV.replace [tempfile.path]
    assert_output('Line 3: 3 elements in stack after evaluation') { RPNBatch.new.process }
  rescue RPNError
    tempfile.unlink
  ensure
    tempfile.unlink
  end

  # TC 27
  # This unit test checks functionalities of hash - put, get,
  # clear, print> Chose Hash for performance consideration.
  # BASE CASE
  def test_hash
    @var_hash.put('X', 1)
    assert_equal 1, @var_hash.get('X')
    assert_equal "X 1\n", @var_hash.print
    @var_hash.clear
    assert_nil @var_hash.get('X')
    assert_equal '', @var_hash.print
  end

  # TC 28
  # This unit test checks functionalities of stack - push, pop,
  # peek, print, clear, size
  # BASE CASE
  def test_stack
    @stack.push(1)
    @stack.push(2)
    assert_equal 2, @stack.size
    assert_equal 2, @stack.peek(-1)
    assert_equal 2, @stack.pop
    assert_equal '[1]', @stack.print
    @stack.clear
    assert_equal 0, @stack.size
  end

  # TC 29
  # This unit test checks that multiple files are processed as
  # one large concatenated file
  # BASE CASE
  def test_batch_process_multiple_files
    tempfile1 = Tempfile.new(['temp1', '.rpn'], '.')
    tempfile2 = Tempfile.new(['temp2', '.rpn'], '.')

    # Temp file 1 defines variable A
    tempfile1.write('LET A 1')

    # Temp file 2 refers to variable A defined in Temp file 1
    tempfile2.write('LET B 3 A *')
    tempfile1.close
    tempfile2.close

    # Now pass both files as command line arguments
    # They should be processed as one concatenated file
    ARGV.replace [tempfile1.path, tempfile2.path]
    assert @batch.process
    assert_equal 1, @batch.var_hash.get('A')
    assert_equal 3, @batch.var_hash.get('B')
    tempfile1.unlink
    tempfile2.unlink
  end

  # TC 30
  # This unit test blank lines should be ignored
  # BASE CASE
  def test_blank_lines_skipped
    lines = ["\n", "\n", 'PRINT 9']
    expected_result = [nil, nil, '9']
    idx = 0
    lines.each do |line|
      output = @batch.each_line(line)
      if expected_result[idx].nil?
        assert_nil output
      else
        assert_equal expected_result[idx], output
      end
      idx += 1
    end
  end

  # UNIT TESTS FOR checking file extension .prn
  # Equivalence classes:
  # file has proper extension .prn -> returns true
  # file does not have .prn        -> exception raised

  # TC 31
  # This unit test checks input file names have proper file
  # extension .rpn
  # BASE CASE
  def test_files_extension_as_rpn
    file_name = 'test_extension.rpn'
    assert rpn_file_extension(file_name)
  end

  # TC 32
  # This unit test cheks file with incorrect extension
  # will cause RuntimeError exception to be raised
  # EDGE CASE
  def test_file_with_incorrect_extension
    # Create a temp file with extension .idk
    tempfile = Tempfile.new(['temp', '.idk'], '.')
    tempfile.write('PRINT 1')
    tempfile.close
    ARGV.replace [tempfile.path]
    assert_raises(RuntimeError) { RPNBatch.new.process }
    tempfile.unlink
  end

  # TC 33
  # This unit test checks that variable values shall not be persisted
  # across executions by creating 2 separate temp files
  # EDGE CASE
  def test_variables_not_persisted_across_executions
    tempfile1 = Tempfile.new(['temp1', '.rpn'], '.')
    tempfile2 = Tempfile.new(['temp2', '.rpn'], '.')
    tempfile1.write('LET A 1')
    tempfile2.write('LET B A 1 +')
    tempfile1.close
    tempfile2.close
    ARGV.replace [tempfile1.path]

    # Temp file 1 defines variable A
    RPNBatch.new.process
    ARGV.replace [tempfile2.path]

    # Temp file 2 refers to variable A, which will raise exception
    assert_raises(RPNError) { RPNBatch.new.process }
  ensure
    tempfile1.unlink
    tempfile2.unlink
  end

  # UNIT TESTS FOR checking numeric calculations
  # Equivalence classes:
  # various valid numeric representation            -> computatoin performed correctly
  # numbers directly or indirectly causing overflow -> exception raised
  # decimal numbers not allowed                     -> exception raised

  # TC 35
  # This unit test checks that there should be no overflow
  # CORNER CASE
  def test_no_overflow
    lines = ['999999999999999999 999999999999999999 *', \
             '2e3 2000 *', '-4_000_000 2_000_000 *']
    expected_result = ['999999999999999998000000000000000001',
                       '4000000', '-8000000000000']
    idx = 0
    lines.each do |line|
      assert_equal expected_result[idx], @repl.input_handler(line)
      idx += 1
    end
  end

  # TC 42
  # This unit test checks that Infinity and -Infinity are captured
  # CORNER CASE
  def test_infinity
    lines = ['LET a 9e8888', 'LET B -9.9e9999', 'LET C 6e8888 -9.9e999 *']
    expected_result = ['Error with number 9e8888', 'Error with number -9.9e9999',
                       'Error with number 6e8888']
    idx = 0
    lines.each do |line|
      begin
        @batch.each_line(line)
      rescue RPNError => e
        assert_equal expected_result[idx], e.message
        idx += 1
      end
    end
  end

  # TC 56
  # This unit test checks that various forms of decimals are not allowed
  # BASE CASE
  def test_deny_decimal
    lines = ['LET A 2.5', '1.5 3.9 +', '1.2e3']
    idx = 0
    lines.each do |line|
      begin
        @repl.input_handler(line)
      rescue RPNError => e
        assert_equal 4, e.error_code
        assert_match /Does not allow decimal/, e.error_msg
        idx += 1
      end
    end
  end

  # TC 36
  # This unit test checks that when non existent file is passed
  # in from command line, program will generate RuntimeError
  # EDGE CASE
  def test_file_not_exist
    ARGV.replace ['nonexist.rpn']
    assert_raises(RuntimeError) { RPNBatch.new.process }
  end

  # TC 37
  # This unit test checks that when input file is emtpy,
  # program will remove empty files from ARGV
  # EDGE CASE
  def test_batch_mode_remove_empty_file_from_argv
    # Create an empty temp file
    tempfile = Tempfile.new(['temp', '.rpn'], '.')

    # Pass in temp file via ARGV
    ARGV.replace [tempfile.path]
    RPNBatch.new.process

    # Verify that program removes empty files from ARGV so they
    # are skipped
    assert_equal 0, ARGV.length
    tempfile.close
    tempfile.unlink
  end

  # TC 38
  # This unit test cheks when division by zero
  # EDGE CASE
  def test_division_by_zero
    @token_eval.eval_binary(2, 0, '/', 1)
  rescue RPNError => e
    assert_equal 5, e.error_code
    assert_equal 'Line 1: Division by zero', e.error_msg
  end

  # TC 39
  # This unit test checks + and - can be both binary and
  # unary operators
  # CORNER CASE
  def test_binary_unary_operators
    vars = %w[A B C D]
    lines = ['LET A -4', 'LET B -4 -1 +', 'LET C +1 -1 +', 'LET D +8']
    expected_result = [-4, -5, 0, 8]
    idx = 0
    lines.each do |line|
      @batch.each_line(line)
      assert_equal expected_result[idx], @batch.var_hash.get(vars[idx])
    end
  end

  # TC 40
  # This unit test checks that in REPL mode, exit confirmation is
  # display when user interrupt is generated
  # BASE CASE
  def test_repl_mode_exit_confirmation
    output = @repl.exit_confirmation('Y')
    assert output
  end

  # TC 41
  # UNIT TESTS FOR METHOD STUB RPNRepl.exit_confirmation
  # BASE CASE
  def test_repl_exit_confirmation
    repl = RPNRepl.new
    mock = MiniTest::Mock.new
    mock.expect :exit_confirmation, true
    assert([repl, :exit_confirmation])
  end

  # TC 44
  # This unit test checks prompt in REPL mode is '> '
  # PROPERTY BASED CASE
  def test_prompt
    assert_equal '> ', RPNDef::PROMPT
  end

  # TC 45
  # This unit test checks static keyword data
  # using property based invariant
  # PROPERTY BASED CASE
  def test_keyword_class_type
    assert_kind_of Hash, RPNDef::KEYWORD
  end

  # TC 46
  # This unit test checks static operators data +, -, *, /
  # using property based invariant
  # PROPERTY BASED CASE
  def test_operators_class_type
    assert_kind_of Hash, RPNDef::OPERATOR
  end

  # SMOKE TESTS for application minimal functionalities
  # Equivalence classes:
  # batch mode    -> intermediate values get thrown away
  # repl mode     -> will always show result of the stack

  # TC 47
  # This unit test checks basic scenarios as Smoke testing in batch mode
  # SMOKE TEST
  def test_batch_mode_base_scenarios_for_deliverable_6
    lines = ['4 3 +', 'LET a 10', 'a 1 +', '2', 'LET b 2 2 +', 'LET c a b +',
             'PRINT C', '10 10 * 5 5 * 0 0 * + +']
    expected_result = ['', '', '', '', '', '', '14', '']
    idx = 0
    lines.each do |line|
      output = @batch.each_line(line).to_s.force_encoding(Encoding::UTF_8)
      assert_equal expected_result[idx], output
      idx += 1
    end
  end

  # TC 48
  # This unit test checks basic scenarios as Smoke testing in repl mode
  # SMOKE TEST
  def test_repl_mode_base_scenarios_for_deliverable_6
    lines = ['4 3 +', 'LET a 10', 'a 1 +', '2', 'LET b 2 2 +', 'LET c a b +',
             'PRINT C', '10 10 * 5 5 * 0 0 * + +']
    expected_result = %w[7 10 11 2 4 14 14 125]
    idx = 0
    lines.each do |line|
      assert_equal expected_result[idx], @repl.input_handler(line)
      idx += 1
    end
  end

  # TC 49
  # The unit test checks blank lines are counted in terms of line number
  # EDGE CASE
  def test_line_count_includes_empty_lines
    tempfile1 = Tempfile.new(['temp5', '.rpn'], '.')
    tempfile2 = Tempfile.new(['temp6', '.rpn'], '.')
    tempfile1.write("\n\n\n")
    tempfile2.write('LET A')
    tempfile1.close
    tempfile2.close

    # Temp file 1 has 3 blank lines. Temp file 2 has one invalid let
    ARGV.replace [tempfile1.path, tempfile2.path]

    assert_output('Line 4: Operator LET applied to empty stack') { RPNBatch.new.process }
  rescue RPNError
  ensure
    tempfile1.unlink
    tempfile2.unlink
  end

  # TC 50
  # UNIT TESTS FOR METHOD STUB RPNBatch.new
  # BASE CASE
  def test_rpn_batch_new_stub
    mock = MiniTest::Mock.new
    mock.expect :var_hash, {}

    RPNBatch.stub :new, mock do
      mock = RPNBatch.new
      assert_equal 0, mock.var_hash.size
    end
  end

  # TC 51
  # UNIT TESTS FOR METHOD STUB RPNRepl.new
  # BASE CASE
  def test_rpn_repl_new_stub
    mock = MiniTest::Mock.new
    mock.expect :var_hash, {}

    RPNRepl.stub :new, mock do
      mock = RPNRepl.new
      assert_equal 0, mock.var_hash.size
    end
  end

  # TC 52
  # UNIT TESTS FOR METHOD STUB RPNBatch.process
  # BASE CASE
  def test_batch_mode_method_process_stub
    batch_mode = RPNBatch.new

    batch_mode.stub :process, '1' do
      assert_equal '1', batch_mode.process
    end
  end

  # TC 53
  # UNIT TESTS FOR METHOD STUB RPNRepl.process
  # BASE CASE
  def test_repl_mode_method_process_stub
    repl_mode = RPNRepl.new

    repl_mode.stub :process, '1' do
      assert_equal '1', repl_mode.process
    end
  end

  # TC 54
  # UNIT TESTS FOR METHOD STUB LineParser.parse
  # BASE CASE
  def test_rpn_line_parser_parse_stub
    line_parser = LineParser.new(@var_hash)

    line_parser.stub :parse, '1' do
      assert_equal '1', line_parser.parse
    end
  end

  # TC 55
  # This unit test checks the scenarios that variables get
  # re-assigned or referred to within the same RPN expression
  # CORNER CASE
  def test_variable_reassignment
    lines = ['LET X 2', 'LET X 10', 'LET Z X 9 +', \
             'LET Z Z Z *', 'LET Z Z Z /', 'LET Z Z Z + Z Z + + Z +']
    expected_result = %w[2 10 19 361 1 5]
    idx = 0
    lines.each do |line|
      assert_equal expected_result[idx], @repl.input_handler(line)
      idx += 1
    end
  end
end
