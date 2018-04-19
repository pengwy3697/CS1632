# Class Stack
# A last in first out data structure to store Reverse Polish Notation
# operands and any itermediate values
class Stack
  def initialize
    @stack = []
  end

  # Method pop
  # pops element off top of the stack
  def pop
    @stack.pop
  end

  # Method push
  # pushes an element to top of the stack
  def push(element)
    @stack.push(element)
  end

  # Method peek
  # peeks the element to top of the stack
  def peek(position)
    @stack[position]
  end

  # Method size
  # gets size of the stack
  def size
    @stack.size
  end

  # Method print
  # prints contents of stack
  def print
    @stack.inspect
  end

  # Method clear
  # clears up contents of stack
  def clear
    @stack = []
  end
end
