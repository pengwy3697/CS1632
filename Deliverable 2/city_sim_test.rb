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

  # UNIT TESTS FOR METHOD reachDestination(x)
  # Tests if the driver reaches the end
  # Class: FunCitySim
  def test_has_reach_destination
    downtown = City.new("Downtown")
    assert_equal true, @sim.reachDestination(downtown)
  end

  # UNIT TESTS FOR FunCitySim.FUN_FIVE_DRIVERS
  # Tests FUN_FIVE_DRIVERS contain "Driver 1"
  # Class: FunCitySim
  def test_FUN_FIVE_DRIVERS
    assert @sim.FUN_FIVE_DRIVERS.include?("Drive 1")
  end

  # UNIT TESTS FOR FUN_FunCitySim.OTHER_PLACES
  # Tests FUN_OTHER_PLACES contain "Monroeville"
  # Class: FunCitySim
  def test_FUN_OTHER_PLACES_has_Monroeville
    assert @sim.FUN_OTHER_PLACES.include?("Monroeville")
  end

  # UNIT TESTS FOR FUN_FunCitySim.FUN_OTHER_PLACES
  # Tests FUN_OTHER_PLACES contain "Downtown"
  def test_FUN_OTHER_PLACES_has_Downtown
    assert @sim.FUN_OTHER_PLACES.include?("Downtown")
  end

  # UNIT TESTS FOR FUN_FunCitySim.FUN_CITY_LOCS
  # Tests if there are 4 cities
  # Class: FunCitySim
  def test_num_of_cities
    assert_equal 4, @sim.FUN_CITY_LOCS.length
  end

  # UNIT TESTS FOR FUN_FunCitySim.FUN_OTHER_PLACES
  # Tests if there are 2 end points
  # Class: FunCitySim
  def test_num_of_other_places
    assert_equal 2, @sim.FUN_OTHER_PLACES.length
  end

  # UNIT TESTS FOR FunCitySim.FUN_FIVE_DRIVERS
  # Tests if there are 5 drivers
  # Class: FunCitySim
  def test_num_of_drivers
    assert_equal 5, @sim.FUN_FIVE_DRIVERS.length
  end

  # UNIT TESTS FOR METHOD City.addNeighbor("neighbor", "test path")
  # Class: City
  # return number of neighbor(s)
  def test_city_neighbors_count
    city = City.new
    city.addNeighbor("neighbor", "test path")
    assert_equal 1, city.neighbors.length
  end

  # UNIT TESTS FOR METHOD Driver.setStartCity("x")
  # Class: Driver
  # should return the name of start city
  def test_driver_set_start_city
    assert_equal "x", @driver.setStartCity("x")
  end

  # UNIT TESTS FOR METHOD Driver.setStartCity("x")
  # Class: Driver
  # should return the name of start city
  def test_driver_set_start_city_nil
    begin
      @driver.setStartCity(nil)
    rescue RuntimeError => e
      assert true
    end
  end

  # UNIT TESTS FOR METHOD Driver.updateCount(loc)
  # Class: Driver
  # book count should be incremented by 1
  def test_driver_books_count
    @driver.updateCounts("Hillman")
    assert_equal 1, @driver.books
  end
  
  # UNIT TESTS FOR METHOD Driver.updateCount(loc)
  # Class: Driver
  # dinosaur count should be incremented by 1
  def test_driver_dinosaurs_count
    @driver.updateCounts("Museum")
    @driver.updateCounts("Museum")
    assert_equal 2, @driver.dinos
  end

  # UNIT TESTS FOR METHOD number of classes count
  # Class: Driver
  # class count should be multiplied by 2
  def test_driver_classes_count
    @driver.updateCounts("Cathedral")
    @driver.updateCounts("Cathedral")
    assert_equal 4, @driver.numClasses
  end

  # UNIT TESTS FOR METHOD FunCitySim.getCityByName
  # that the city name is nonexistent
  # Class: FunCitySim
  # return nil if city name is nonexistent
  def test_get_city_by_nonexistent
    city = @sim.getCityByName("Phatom City")
    assert_nil(city)
  end

  # UNIT TESTS FOR METHOD FunCitySim.getCityByName(c)
  # that the city name is nil
  # Class: FunCitySim
  # return nil if city name is nil
  def test_get_city_by_nonexistent
    city = @sim.getCityByName(nil)
    assert_nil(city)
  end

  # UNIT TESTS FOR METHOD FunCitySim.reachDestination(c)
  # that the city name is nil
  # Class: FunCitySim
  # return true if city name is nil
  def test_reach_destination_by_nil
    assert_equal true, @sim.reachDestination(nil)
  end
  
  # UNIT TESTS FOR METHOD FunCitySim.reachDestination(c)
  # that the city name is nonexistent
  # Class: FunCitySim
  # return false if city name is nonexistent
  def test_reach_destination_by_nonexistent
    nonexistent = City.new("nonexistent")
    assert_equal false, @sim.reachDestination(nonexistent)
  end


end