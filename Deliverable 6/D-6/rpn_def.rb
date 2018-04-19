# Class RPNDef
# A class to store static definitions as required by the RPN processor
class RPNDef
  PROMPT = '> '.freeze
  KEYWORD = { 'QUIT' => true, 'LET' => true, 'PRINT' => true }.freeze
  OPERATOR = { '+' => true, '-' => true, '*' => true, '/' => true }.freeze
end
