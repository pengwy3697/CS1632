require 'minitest/autorun'
require 'City'
require 'Neighbor'
require 'Driver'
require 'FunCitySim'
require 'CitySimUtil'

class SimTest < Minitest::Test
  def setup
    @sim = FunCitySim.new
    @sim.InitStaticData()

    @driver = Driver.new("test driver")
    @driver.setStartCity("Hospital")

    @util = CitySimUtil.new()
  end

  # Tests if more than one argument is provided
  def test_command_too_many_args
    begin
      @util.validateArg(["111","222","333"])
    rescue RuntimeError => e
      assert true
    end
  end

  # Tests if no arguments are provided
  def test_command_no_args
    begin
      @util.validateArg([])
    rescue RuntimeError => e
      assert true
    end
  end

  def test_command_invalid_args
    begin
      assert_equal true, @util.validateArg(["xyz"]) == 0
    end
  end

  def test_random_generator_seed
    begin
      @util.setRandomSeed(123)
      random1 = @util.genRandom(5)
      @util.setRandomSeed(456)
      random2 = @util.genRandom(5)
      assert_equal false, random1 == random2
    end
  end

  # UNIT TESTS FOR METHOD reachDestination(x)
  # Tests if the driver reaches the end
  # Class: FunCitySim
  def test_has_reach_destination
    downtown = City.new("Downtown")
    assert_equal true, @sim.reachDestination(downtown)
  end

  # Tests FUN_FIVE_DRIVERS contain "Driver 1"
  # Class: FunCitySim
  def test_FUN_FIVE_DRIVERS
    assert @sim.FUN_FIVE_DRIVERS.include?("Drive 1")
  end

  # Tests FUN_OTHER_PLACES contain "Monroeville"
  # Class: FunCitySim
  def test_FUN_OTHER_PLACES_has_Monroeville
    assert @sim.FUN_OTHER_PLACES.include?("Monroeville")
  end

  # Tests FUN_OTHER_PLACES contain "Downtown"
  def test_FUN_OTHER_PLACES_has_Downtown
    assert @sim.FUN_OTHER_PLACES.include?("Downtown")
  end

  # Tests if there are 4 cities
  def test_num_of_cities
    assert_equal 4, @sim.FUN_CITY_LOCS.length
  end

  # Tests if there are 2 end points
  def test_num_of_other_places
    assert_equal 2, @sim.FUN_OTHER_PLACES.length
  end

  # Tests if there are 5 drivers
  def test_num_of_drivers
    assert_equal 5, @sim.FUN_FIVE_DRIVERS.length
  end

  # UNIT TESTS FOR METHOD addNeighbor("neighbor", "test path")
  # Class: City
  def test_city_neighbors_count
    city = City.new
    city.addNeighbor("neighbor", "test path")
    assert_equal 1, city.neighbors.length
  end

  # UNIT TESTS FOR METHOD setStartCity("x")
  # Class: Driver
  def test_driver_set_start_city
    assert_equal "x", @driver.setStartCity("x")
  end

  # UNIT TESTS FOR METHOD travel("x", "y", "st")
  # Class: Driver
  def test_driver_travel
    fromCity = @sim.getCityByName("Museum")
    toCity = @sim.getCityByName("Hillman")
    @driver.travel(fromCity, toCity, "Fifth Ave")
    assert_equal 1, @driver.books
  end

  # UNIT TESTS number of classes count
  # Class: Driver
  def test_driver_classes_count
    @driver.setStartCity("Cathedral")
    assert_equal 2, @driver.numClasses
  end

  # Tests if driver has been through a circular path before.
  # Expected false
  # Class: Driver
  def test_loop_exists_false
    assert_equal false, @driver.loopExists("x", "y")
  end

  # This unit test checks FunCitySim.getCityByName method
  # that the city name is nonexistent
  def test_get_city_by_nonexistent
    city = @sim.getCityByName("Phatom City")
    assert_nil(city)
  end

  # This unit test checks FunCitySim.getCityByName method
  # that the city name is nil
  def test_get_city_by_nonexistent
    city = @sim.getCityByName(nil)
    assert_nil(city)
  end

  # This unit test checks FunCitySim.reachDestination method
  # that the city name is nil
  def test_reach_destination_by_nil
    assert_equal true, @sim.reachDestination(nil)
  end

  # This unit test checks FunCitySim.reachDestination method
  # that the city name is nonexistent
  def test_reach_destination_by_nonexistent
    nonexistent = City.new("nonexistent")
    assert_equal false, @sim.reachDestination(nonexistent)
  end

  # This unit test checks CitySimUtil.setRandomSeed method
  # that the random number seed is negative
  # EDGE CASE
  def test_random_generator_seed_negative
    begin
      @util.setRandomSeed(-11111111111111111111)
    rescue RuntimeError => e
      assert true
    end
  end

  # This unit test checks CitySimUtil.genRandom method
  # that the random number range is negative
  # EDGE CASE
  def test_random_generator_range_negative
    begin
      @util.setRandomSeed(111)
      random1 = @util.genRandom(-10)
    rescue RuntimeError => e
      assert true
    end
  end

  # This unit test checks CitySimUtil.genRandom method
  # that the random number range is zero
  # EDGE CASE
  def test_random_generator_range_zero
    begin
      @util.setRandomSeed(111)
      random1 = @util.genRandom(0)
    rescue RuntimeError => e
      assert true
    end
  end
end