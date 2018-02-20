

##############################################################################################################
#
# Encapsulate all static data within this class
# 
##############################################################################################################
class FunCitySim
  def initialize
    @FUN_CITY_LOCS = []
    @FUN_OTHER_PLACES = ["Monroeville", "Downtown"]
    @FUN_FIVE_DRIVERS = ["Driver 1", "Driver 2", "Driver 3", "Driver 4", "Driver 5"]
  end
  
  ##############################################################################################################
  # Method InitStaticData
  #       It initializes the static data used for the Fun City Traversal Simulation
  ##############################################################################################################
  
  def InitStaticData
    hospital = City.new("Hospital")
    hospital.addNeighbor("Cathedral", "Fourth Ave")
    hospital.addNeighbor("Hillman", "Foo St")
    @FUN_CITY_LOCS << hospital
    
    cathedral = City.new("Cathedral")
    cathedral.addNeighbor("Museum", "Bar St")
    cathedral.addNeighbor("Monroeville", "Fourth Ave")
    @FUN_CITY_LOCS << cathedral
    
    museum = City.new("Museum")
    museum.addNeighbor("Cathedral", "Bar St")
    museum.addNeighbor("Hillman", "Fifth Ave")
    @FUN_CITY_LOCS << museum
    
    hillman  = City.new("Hillman")
    hillman.addNeighbor("Hospital", "Foo St")
    hillman.addNeighbor("Downtown", "Fifth Ave")
    @FUN_CITY_LOCS << hillman
  end
  
  def getCityByName(cityName)
    @FUN_CITY_LOCS.find { |loc| loc.name == cityName }
  end
  
  def reachDestination(cityObj)
    if cityObj == nil
      true
    elsif @FUN_OTHER_PLACES.find { |loc| loc == cityObj.name}
      true
    else
      false
    end
  end
    
  attr_reader :FUN_CITY_LOCS
  attr_reader :FUN_OTHER_PLACES
  attr_reader :FUN_FIVE_DRIVERS
end