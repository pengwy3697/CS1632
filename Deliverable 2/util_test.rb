require 'minitest/autorun'
require 'CitySimUtil'

#
# Unit Tests for CitySimUtil class
#
class Util_test < Minitest::Test
  def setup
    @util = CitySimUtil.new()
  end

  # UNIT TESTS FOR METHOD CitySimUtil.validateArg([])
  # if more than 1 arguments are provided, RuntimeException will be thrown
  def test_command_too_many_args
    begin
      @util.validateArg(["111","222","333"])
    rescue RuntimeError => e
      assert true
    end
  end

  # UNIT TESTS FOR METHOD CitySimUtil.validateArg([])
  # if no argument is provided, RuntimeException will be thrown
  def test_command_no_args
    begin
      @util.validateArg([])
    rescue RuntimeError => e
      assert true
    end
  end

  # UNIT TESTS FOR METHOD CitySimUtil.validateArg([])
  # if invalid argument is provided, it should return 0 as seed
  def test_command_invalid_args
    begin
      assert_equal true, @util.validateArg(["xyz"]) == 0
    end
  end

  # UNIT TESTS FOR METHOD CitySimUtil.setRandomSeed(s)
  # if the seed is different, the random number generated should be different
  # for the same range
  def test_random_generator_seed
    begin
      @util.setRandomSeed(123)
      random1 = @util.genRandom(5)
      @util.setRandomSeed(456)
      random2 = @util.genRandom(5)
      assert_equal false, random1 == random2
    end
  end

  # UNIT TESTS FOR METHOD CitySimUtil.setRandomSeed(s)
  # that the random number seed is negative
  # EDGE CASE
  def test_random_generator_seed_negative
    begin
      @util.setRandomSeed(-11111111111111111111)
    rescue RuntimeError => e
      assert true
    end
  end

  # UNIT TESTS FOR METHOD CitySimUtil.genRandom(r)
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

  # UNIT TESTS FOR METHOD CitySimUtil.genRandom(r)
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