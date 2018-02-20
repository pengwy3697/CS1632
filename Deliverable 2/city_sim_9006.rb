require 'City'
require 'Neighbor'
require 'Driver'
require 'FunCitySim'
require 'CitySimUtil'


##############################################################################################################
#
# Main program begins here
#
##############################################################################################################

begin
  
  # Check the existence of one and only one seed.
  # Throws RunTimeError if validation condition is not met
  util = CitySimUtil.new
  rndGnrtSeed = util.validateArg(ARGV)

  util.setRandomSeed(rndGnrtSeed)
  
  sim = FunCitySim.new
  sim.InitStaticData()
  
  # Launch each of the 5 drivers one after another
  # Use random number to select a starting city from the four FUN CITY LOCS
  
  (0..4).each do |i|
    driver = Driver.new(sim.FUN_FIVE_DRIVERS[i])
    # start city random number
    cityLocRnd = util.genRandom(4)
    fromCity = sim.FUN_CITY_LOCS[cityLocRnd]
    driver.setStartCity(fromCity.name)
    done = false
    while !done do
      
      driver.updateCounts(fromCity.name())
      # neighbor random number
      neighborRnd = util.genRandom(fromCity.neighbors.length)
      toCity = sim.getCityByName(fromCity.neighbors[neighborRnd].name)
      
      # Driver continues travelling until either Monroeville or Downtown is reached
      if sim.reachDestination(toCity)
        driver.updateCounts(toCity)
        puts driver.name  + " heading from " + fromCity.name + " to " + fromCity.neighbors[neighborRnd].name + " via " + fromCity.neighbors[neighborRnd].path
        done = true;
      else
        driver.travel(fromCity, toCity, fromCity.neighbors[neighborRnd].path)
        fromCity = toCity
      end
    end
    
    # At end of the trip, driver prints out books/toys/classes tallies 
    driver.summarizeTrip

  end # driver do
end
