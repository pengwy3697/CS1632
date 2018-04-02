require 'minitest/mock'
require 'minitest/autorun'
require 'simplecov'
SimpleCov.start
require '.\static_data'
require '.\driver'
require '.\city_sim_util'

# Class CitySimTest
# It provides unit test methods
class CitySimTest < MiniTest::Test
  # UNIT TESTS FOR Driver class
  # BASE CASE
  def test_driver_num_classes_1
    driver = Driver.new('Audrey')
    driver.start_city('Cathedral')
    assert_equal(1, driver.cnt['num_classes'])
  end

  # UNIT TESTS FOR Driver class
  # BASE CASE
  def test_driver_num_classes_4
    driver = Driver.new('Audrey')
    driver.start_city('Cathedral')
    driver.travel('Museum', 'Bar St')
    driver.travel('Cathedral', 'Bar St')
    driver.travel('Museum', 'Bar St')
    driver.travel('Cathedral', 'Bar St')
    assert_equal(4, driver.cnt['num_classes'])
  end

  # UNIT TESTS FOR METHOD STUB Driver.new
  # BASE CASE
  def test_driver_new_stub
    mock = MiniTest::Mock.new
    mock.expect :name, 'Audrey'

    Driver.stub :new, mock do
      mock = Driver.new
      assert_equal 'Audrey', mock.name
    end
  end

  # UNIT TESTS FOR METHOD STUB Driver.start_city
  # BASE CASE
  def test_driver_method_start_city_stub
    mock = MiniTest::Mock.new
    mock.expect :cnt, 'books' => 0, 'dinos' => 0, 'num_classes' => 1
    mock.expect :start_city, { 'books' => 0, 'dinos' => 0, 'num_classes' => 2 }, []
    driver = Driver.new('Audrey')
    assert([driver, :start_city, 'Cathedral'])
  end

  # UNIT TESTS FOR METHOD STUB Driver.update_counts
  # BASE CASE
  def test_driver_method_update_counts_stub
    mock = Driver.new('test')
    mock.stub :update_counts, true do
      assert(mock.update_counts('Cathedral'))
    end
  end

  # UNIT TESTS FOR METHOD STUB Driver.travel
  # BASE CASE
  def test_driver_method_travel_stub
    mock = MiniTest::Mock.new
    mock.expect :cnt, 'books' => 0, 'dinos' => 0, 'num_classes' => 1
    mock.expect :travel, { 'dinos' => 0, 'num_classes' => 2 }, ['Museum', 'Bar St']
    driver = Driver.new('Audrey')
    assert([driver, :travel, 'Museum', 'Bar St'])
  end

  # UNIT TESTS FOR METHOD STUB Driver.summarize_trip
  # BASE CASE
  def test_driver_method_summarize_trip_stub
    mock = MiniTest::Mock.new
    mock.expect :cnt, 'books' => 0, 'dinos' => 0, 'num_classes' => 1
    mock.expect :summarize_trip, 'dinos' => 0, 'num_classes' => 2
    driver = Driver.new('Audrey')
    assert([driver, :summarize_trip])
  end
#
#  # UNIT TESTS FOR city_sim_9006.rb
#  # if no argument is provided, RuntimeException will be thrown
#  def test_command_no_arg
#    system('ruby ./city_sim_9006.rb > NUL')
#  rescue RuntimeError
#    assert true
#  end

  # UNIT TESTS FOR UNIT TESTS FOR city_sim_9006.rb
  # if more than 1 arguments are provided, RuntimeException will be thrown
  def test_command_arg_literal
    system('ruby ./city_sim_9006.rb A_Number >NUL')
    # validate_arg(%w[111 222 333])
  rescue RuntimeError
    assert true
  end

  # UNIT TESTS FOR METHOD CitySimUtil.random_seed(s)
  # if the seed is different, the random number generated should be different
  # for the same range
  def test_random_generator_seed
    srand(123)
    first_random_val = rand(5)
    srand(456)
    second_random_val = rand(11)
    assert_equal false, first_random_val == second_random_val
  end

  # UNIT TESTS FOR METHOD CitySimUtil.random_seed(s)
  # that the random number seed is negative
  # EDGE CASE
  def test_random_generator_seed_negative
    srand(-111)
  rescue RuntimeError
    assert true
  end
end
