# Note that we require and start simplecov before
# doing ANYTHING else, including other require statements.
require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require_relative 'static_data'
require_relative 'driver'
require_relative 'city_sim_util'

# Class CitySimTest
# It provides unit test methods
class CitySimTest < MiniTest::Test
  def setup
    @driver = Driver.new('Audrey', 'Hospital')
  end

  # This unit test checks METHOD gen_random(s)
  # if the seed is same, the random numbers generated should be the same
  # BASE CASE
  def test_same_seed_same_output
    first_random_val = gen_random(123)
    second_random_val = gen_random(123)
    assert_equal true, first_random_val == second_random_val
  end

  # This unit test checks METHOD gen_random(s)
  # if the seed is same, the random numbers generated should be the same
  # for a given range
  # BASE CASE
  def test_same_seed_same_output_with_given_range
    first_random_val = gen_random(123, 4)
    second_random_val = gen_random(123, 4)
    assert_equal true, first_random_val == second_random_val
  end

  # This unit test checks METHOD gen_random(s)
  # if the seed is different, the random numbers generated should be different
  # BASE CASE
  def test_diff_seed_diff_output
    first_random_val = gen_random(888)
    second_random_val = gen_random(999)
    assert_equal false, first_random_val == second_random_val
  end

  # This unit test checks METHOD gen_random(s)
  # if the seed is different, the random numbers generated should be different
  # within a given range
  # BASE CASE
  def test_diff_seed_diff_output_with_given_range
    first_random_val = gen_random(888, 4)
    second_random_val = gen_random(999, 4)
    assert_equal false, first_random_val == second_random_val
  end

  # This unit test checks METHOD validate_arg([])
  # program will accept if a valid argument is provided as seed
  # EDGE CASE
  def test_command_with_valid_arg
    assert_equal 10, validate_arg([10])
  end

  # This unit test checks METHOD validate_arg([])
  # if no argument is provided, RuntimeException will be thrown
  # EDGE CASE
  def test_command_with_no_args
    validate_arg([])
  rescue RuntimeError
    assert true
  end

  # This unit test checks validate_arg([])
  # if more than 1 arguments are provided, RuntimeException will be thrown
  # EDGE CASE
  def test_command_with_too_many_args
    validate_arg(%w[111 222 333])
  rescue RuntimeError
    assert true
  end

  # This unit test checks METHOD validate_arg([])
  # if invalid argument is provided, it should return 0 as seed
  # EDGE CASE
  def test_command_with_invalid_args
    assert_equal true, validate_arg(['xyz']).zero?
  end

  # This unit test checks what happens when we pass in invalid routes
  # for driver to travel through
  # EDGE CASE
  def test_drivers_can_not_travel_via_invalid_route
    driver = Driver.new('test', 'Hospital')
    [['Pittsburg', 'by foot'], ['Bed', 'by climb'], ['Heaven', 'in dream']].each do |route|
      assert_raises(RuntimeError) { driver.travel(route[0], route[1]) }
    end
  end

  # This unit test checks what happens when we pass in city values other
  # than 'Monroeville' and 'Downtown'
  # EDGE CASE
  def test_destination_contain_valid_values_only
    [nil, -1, 1, 'Chicago', 'San Francisco'].each do |invalid_city|
      refute_includes StaticData::FUN_END, invalid_city
    end
  end

  # This unit test checks what happens when we pass in values other
  # than 'Driver 1' through 'Driver 5'
  # EDGE CASE
  def test_drivers_contain_valid_values_only
    [nil, -1, 1, 'Laboon', 'Krithika', 'aky13'].each do |invalid_driver|
      refute_includes StaticData::FUN_FIVE_DRIVERS, invalid_driver
    end
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

  # UNIT TESTS FOR METHOD STUB Driver.book_literal
  # BASE CASE
  def test_driver_method_book_literal_stub
    mock = MiniTest::Mock.new
    literals = %w[book books]
    literals.each do |literal|
      mock.expect :book_literal, literal
      assert_equal literal, mock.book_literal
    end
  end

  # UNIT TESTS FOR METHOD STUB Driver.dino_literal
  # BASE CASE
  def test_driver_method_dino_literal_stub
    mock = MiniTest::Mock.new
    literals = ['dinosaur toy!', 'dinosaur toys!']
    literals.each do |literal|
      mock.expect :dino_literal, literal
      assert_equal literal, mock.dino_literal
    end
  end

  # UNIT TESTS FOR METHOD STUB Driver.class_literal
  # BASE CASE
  def test_driver_method_class_literal_stub
    mock = MiniTest::Mock.new
    literals = %w[class classes]
    literals.each do |literal|
      mock.expect :class_literal, literal
      assert_equal literal, mock.class_literal
    end
  end

  # UNIT TESTS FOR METHOD STUB Driver.update_counts
  # BASE CASE
  def test_driver_method_update_counts_stub
    mock = MiniTest::Mock.new
    mock.expect :update_counts, 'books' => 0, 'dinos' => 1, 'num_classes' => 6
    result = mock.update_counts
    assert_equal 6, result['num_classes']
  end

  # UNIT TESTS FOR METHOD STUB Driver.travel
  # BASE CASE
  def test_driver_method_travel_stub
    mock = MiniTest::Mock.new
    mock.expect :travel, { 'books' => 1, 'dinos' => 2 }, ['city x', 'str y']
    result = mock.travel('city x', 'str y')
    assert_equal 1, result['books']
    assert_equal 2, result['dinos']
  end

  # UNIT TESTS FOR METHOD STUB Driver.summarize_trip
  # BASE CASE
  def test_driver_method_summarize_trip_stub
    driver = Driver.new('Audrey', 'Hospital')
    mock = MiniTest::Mock.new
    mock.expect :cnt, 'books' => 0, 'dinos' => 0, 'num_classes' => 1
    mock.expect :summarize_trip, 'dinos' => 0, 'num_classes' => 2
    assert([driver, :summarize_trip])
  end

  # UNIT TESTS FOR METHOD gen_random_start_city
  # Iterate 5 times to generate a random start city.
  # Verify the random city is defined in FUN-CITY-LOCS each time.
  # BASE CASE
  def test_gen_random_start_city
    5.times do
      random_city = gen_random_start_city
      assert_includes StaticData::FUN_CITY_LOCS, random_city
    end
  end

  # This unit test checks METHOD gen_random_next_city
  # For each of the FUN-CITY-LOCS, verify the next random city is
  # within its possible neighboring locations
  # BASE CASE
  def test_gen_random_next_city
    cities = %w[Hospital Cathedral Museum Hillman]

    cities.each do |city|
      random_city = gen_random_next_city(city)
      assert_includes StaticData::CITY_MAP[city], random_city
    end
  end

  # This unit test checks FUN-END cities: Monroeville Downtown
  # BASE CASE
  def test_fun_end_cities
    destinations = %w[Monroeville Downtown]
    destinations.each do |dest|
      assert_includes StaticData::FUN_END, dest
    end
  end

  # This unit test checks FUN_CITY_LOCS: Hospital Cathedral Museum Hillman
  # BASE CASE
  def test_fun_city_locs
    cities = %w[Hospital Cathedral Museum Hillman]
    cities.each do |city|
      assert_includes StaticData::FUN_CITY_LOCS, city
    end
  end

  # This unit test checks routes for FUN-CITY-LOCS are defined in internal hash
  # BASE CASE
  def test_fun_city_map
    cities = %w[Hospital Cathedral Museum Hillman]
    cities.each do |city|
      refute_nil StaticData::CITY_MAP[city]
    end
  end

  # This unit test checks valid FUN-FIVE-DRIVERS
  # BASE CASE
  def test_fun_five_drivers
    (1..5).each do |num|
      assert_includes StaticData::FUN_FIVE_DRIVERS, 'Driver ' + num.to_s
    end
  end

  # This unit test checks car always end up going to Monroeville or Downtown
  # for each of the FUN-CITY-LOCS
  # BASE CASE
  def test_car_always_reach_end_ctiy
    %w[Hospital Cathedral Museum Hillman].each do |city|
      reach_end = StaticData::FUN_END[city]
      until reach_end
        city = gen_random_next_city(city)[0]
        reach_end = StaticData::FUN_END[city]
      end
      assert reach_end
    end
  end

  # This unit test checks driver starts with zero counts
  # BASE CASE
  def test_driver_starts_with_zero_counts
    driver = Driver.new('Audrey', 'Hospital')
    assert_equal 0, driver.cnt['books']
    assert_equal 0, driver.cnt['dinos']
    assert_equal 0, driver.cnt['num_classes']
  end

  # This unit test checks the number of books is correctly calculated
  # BASE CASE
  def test_driver_has_correct_book_counts
    driver = Driver.new('Audrey', 'Hospital')
    driver.travel('Hillman', 'Foo St')
    driver.travel('Hospital', 'Foo St')
    driver.travel('Hillman', 'Foo St')
    assert_equal 2, driver.cnt['books']
  end

  # This unit test checks the number of dinos count is correctly calculated
  # BASE CASE
  def test_driver_has_correct_dino_counts
    driver = Driver.new('Audrey', 'Museum')
    2.times do
      driver.travel('Cathedral', 'Bar St')
      driver.travel('Museum', 'Bar St')
    end
    assert_equal 3, driver.cnt['dinos']
  end

  # This unit test checks the number of attended class count is correctly calculated
  # BASE CASE
  def test_driver_has_correct_class_counts
    driver = Driver.new('Audrey', 'Museum')
    3.times do
      driver.travel('Cathedral', 'Bar St')
      driver.travel('Museum', 'Bar St')
    end
    assert_equal 4, driver.cnt['num_classes']
  end

  # This unit test checks METHOD Driver.summarize_trip
  # It shall print out summary tallies as expected
  # BASE CASE
  def test_driver_method_summarize_trip_output_string
    driver = Driver.new('Audrey', 'Hospital')
    expected = "Audrey obtained 0 books!\nAudrey obtained 0 dinosaur toys!\nAudrey attended 0 classes!"
    assert_equal expected, driver.summarize_trip
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_fun_end_class_type
    assert_kind_of Hash, StaticData::FUN_END
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_fun_city_locs_class_type
    assert_kind_of Array, StaticData::FUN_CITY_LOCS
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_city_map_class_type
    assert_kind_of Hash, StaticData::CITY_MAP
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_fun_five_drivers_class_type
    assert_kind_of Array, StaticData::FUN_FIVE_DRIVERS
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_fun_end_not_empty
    refute_empty StaticData::FUN_END
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_fun_city_locs_not_empty
    refute_empty StaticData::FUN_CITY_LOCS
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_city_map_not_empty
    refute_empty StaticData::CITY_MAP
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_fun_five_drivers_not_empty
    refute_empty StaticData::FUN_FIVE_DRIVERS
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_driver_class_type
    assert Driver.new('test', 'Hospital').is_a?(Driver)
  end

  # This unit test checks static data used by City Sim
  # using property based invariant
  # BASE CASE
  def test_driver_not_nil
    driver = Driver.new('test', 'Hospital')
    refute_nil driver
  end

  # UNIT TESTS FOR METHOD Driver.book_literal
  # Equivalence classes:
  # book count = 0 or > 1 -> returns 'books!'
  # book count = 1 -> returns 'book!'

  # If book count = 0 then 'books!'
  def test_driver_method_book_plural_for_zero_cnt
    driver = Driver.new('test', 'Hospital')
    assert_equal 0, driver.cnt['books']
    assert_equal 'books!', driver.book_literal
  end

  # If book count = 1, then 'book!'
  def test_driver_method_book_singular
    driver = Driver.new('test', 'Hillman')
    assert_equal 1, driver.cnt['books']
    assert_equal 'book!', driver.book_literal
  end

  # If book count > 1, then 'books!'
  def test_driver_method_book_plural
    driver = Driver.new('test', 'Hillman')
    driver.travel('Hospital', 'Foo St')
    driver.travel('Hillman', 'Foo St')
    assert_equal 2, driver.cnt['books']
    assert_equal 'books!', driver.book_literal
  end

  # UNIT TESTS FOR METHOD Driver.dino_literal
  # Equivalence classes:
  # dinosaur toy count = 0 or > 1 -> returns 'dinosaur toys!'
  # dinosaur toy count = 1 -> returns 'dinosaur toy!'

  # If dinosaur toy count = 0 then 'dinosaur toys!'
  def test_driver_method_dino_plural_for_zero_cnt
    driver = Driver.new('test', 'Hospital')
    assert_equal 0, driver.cnt['dinos']
    assert_equal 'dinosaur toys!', driver.dino_literal
  end

  # If dinosaur toy count = 1 then 'dinosaur toy!'
  def test_driver_method_dino_singular
    driver = Driver.new('test', 'Museum')
    assert_equal 1, driver.cnt['dinos']
    assert_equal 'dinosaur toy!', driver.dino_literal
  end

  # If dinosaur toy count > 1 then 'dinosaur toys!'
  def test_driver_method_dino_plural
    driver = Driver.new('test', 'Museum')
    driver.travel('Cathedral', 'Bar St')
    driver.travel('Museum', 'Bar St')
    assert_equal 2, driver.cnt['dinos']
    assert_equal 'dinosaur toys!', driver.dino_literal
  end

  # UNIT TESTS FOR METHOD Driver.class_literal
  # Equivalence classes:
  # attendedclass count = 0 or > 1 -> returns 'classes!'
  # attended class count = 1 -> returns 'class!'

  # If class count = 0 then 'classes!'
  def test_driver_method_class_plural_for_zero_cnt
    driver = Driver.new('test', 'Hospital')
    assert_equal 0, driver.cnt['num_classes']
    assert_equal 'classes!', driver.class_literal
  end

  # If class count <= 1 then 'class!'
  def test_driver_method_class_singular
    driver = Driver.new('test', 'Cathedral')
    assert_equal 1, driver.cnt['num_classes']
    assert_equal 'class!', driver.class_literal
  end

  # If class count > 1 then 'classes!'
  def test_driver_method_class_plural
    driver = Driver.new('test', 'Cathedral')
    driver.travel('Museum', 'Bar St')
    driver.travel('Cathedral', 'Bar St')
    assert_equal 2, driver.cnt['num_classes']
    assert_equal 'classes!', driver.class_literal
  end
end
