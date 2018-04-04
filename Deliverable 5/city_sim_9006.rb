require_relative 'static_data'
require_relative 'city_sim_util'
require_relative 'driver'

# Main program begins here
random_seed = 0

begin
  # Check the existence of one and only one seed.
  # Throws RunTimeError if validation condition is not met
  random_seed = validate_arg(ARGV)
rescue RuntimeError => e
  abort "#{e.backtrace.join("\n")}: Enter a seed and only a seed (#{e.class})"
end

begin
  srand(random_seed)

  # Launch each of the driver one after another
  # Use random number to select a starting city from the four FUN CITY LOCS
  (0..StaticData::FUN_FIVE_DRIVERS.length - 1).each do |i|
    # Select random start city
    from_city = gen_random_start_city
    driver = Driver.new(StaticData::FUN_FIVE_DRIVERS[i], from_city)
    reached_end = false

    until reached_end
      # Select random neighboring city
      to_city = gen_random_next_city(from_city)

      # Driver continues travelling until either Monroeville
      # or Downtown is reached
      puts driver.travel(to_city[0], to_city[1])
      from_city = to_city[0]
      reached_end = true if StaticData::FUN_END[from_city]
    end
    # At end of the trip, driver prints out books, toys, classes tallies
    puts driver.summarize_trip
  end
end
