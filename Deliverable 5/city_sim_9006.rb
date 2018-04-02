require '.\static_data'
require '.\driver'

# Main program begins here
rnd_gnrt_seed = 0
begin
  # Check the existence of one and only one seed.
  # Throws RunTimeError if validation condition is not met
  # util = CitySimUtil.new
  raise RuntimeError if ARGV.length != 1
  rnd_gnrt_seed = ARGV[0].to_i unless ARGV[0].match(/\A[+-]?\d+?(\.\d+)?\Z/).nil?
rescue RuntimeError => e
  abort "#{e.backtrace}) Enter a seed and only a seed (#{e.class})"
end

begin
  # rnd_gnrt_seed = ARGV[0].to_i
  srand(rnd_gnrt_seed)
  @data = StaticData.new

  # Launch each of the 5 drivers one after another
  # Use random number to select a starting city from the four FUN CITY LOCS
  (0..4).each do |i|
    driver = Driver.new(@data.fun_five_drivers[i])

    # start city random number
    random_city_idx = rand(0..@data.all_cities.length - 1)
    from_city = @data.all_cities[random_city_idx]
    driver.start_city(from_city)
    done = false

    until done
      # neighbor random number
      random_city_idx = rand(0..@data.city_hash[from_city].length - 1)
      to_city = @data.city_hash[from_city][random_city_idx][0]

      # Driver continues travelling until either Monroeville
      # or Downtown is reached
      driver.travel(to_city, @data.city_hash[from_city][random_city_idx][1])
      from_city = to_city
      done = true if @data.destination[to_city]
    end
    # At end of the trip, driver prints out books, toys, classes tallies
    driver.summarize_trip
  end
end
