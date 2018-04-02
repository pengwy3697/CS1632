# Class Driver
# It maintains the driver name, visited path and internal books, toys, classes counts
class Driver
  def initialize(name)
    @name = name
    @cnt = { 'books' => 0, 'dinos' => 0, 'num_classes' => 0 }
    @location = ''
  end

  # Method set_start_city(location)
  # sets the starting city of the driver
  # SUCCESS CASES: location attribute is set

  def start_city(location)
    @location = location
    update_counts
  end

  # Method travel
  # takes 2 input arguments: to_city and path
  # SUCCESS CASES: prints travel path
  def travel(to_city, take_ave_street)
    puts @name + ' heading from ' + @location + ' to ' + to_city + ' via ' + take_ave_street
    @location = to_city
    update_counts
  end

  # Method update_counts
  # update Driver attributes books, dinos, num_classes
  # SUCCESS CASES: update internal counts
  def update_counts
    if @location == 'Museum'
      @cnt['dinos'] += 1
    elsif @location == 'Hillman'
      @cnt['books'] += 1
    elsif @location == 'Cathedral'
      @cnt['num_classes'] *= 2
      @cnt['num_classes'] = 1 if @cnt['num_classes'].zero?
    end
  end

  # Method summarize_trip
  # prints out books, toys, classes counts
  def summarize_trip
    puts @name + ' obtained ' + @cnt['books'].to_s + book_literal + "\n" +
         @name + ' obtained ' + @cnt['dinos'].to_s + dino_literal + "\n" +
         @name + ' attended ' + @cnt['num_classes'].to_s + class_literal
  end

  def book_literal
    # :nocov:
    ' book!' if @cnt['books'] == 1
    ' books!'
    # :nocov:
  end

  def dino_literal
    # :nocov:
    ' dinosaur toy!' if @cnt['dinos'] == 1
    ' dinosaur toys!'
    # :nocov:
  end

  def class_literal
    # :nocov:
    ' class!' if @cnt['num_classes'] == 1
    ' classes!'
    # :nocov:
  end

  attr_reader :name, :cnt, :location

  private

  attr_writer :name, :cnt, :location
end
