
##############################################################################################################
# Class Driver
#       It maintains the driver name ("Driver 1", "Driver 2", etc),
#                        visited path array in the form of city1-city2
#                                                          (such as "Hospital-Hillman", "Hillman-Museum",etc)
#                        visited loop array in the form of city1<->city2
#                                                          (such as "Hospital<->Hillman", "Cathedral<->Museum",etc)
#                        and various internal books/toys/classes counts
##############################################################################################################

SIM_LOC_LIBRARY = "Hillman"
SIM_LOC_MUSEUM  = "Museum"
SIM_LOC_LEARNING  = "Cathedral"

class Driver
  def initialize (name)
    @name = name
    @books = 0
    @dinos = 0
    @numClasses = 1
    @visitedPath = []
    @visitedLoop = []
  end
  
  ##############################################################################################################
  # Method setStartCity(location)
  # sets the starting city of the driver
  # SUCCESS CASES: location attribute is set
  ##############################################################################################################

  def setStartCity(location)
    if (location == nil)
      raise RuntimeError, "start city cannot be nil"
    else
      @location = location
    end
  end
  
  ##############################################################################################################
  # Method travel(fromCity, toCity, wantToTakeAveStr)
  # takes 2 input arguments: startCity and toCity and updates attribute location and visited
  # SUCCESS CASES: prints travel path
  ##############################################################################################################
  def travel(fromCity, toCity, wantToTakeAveStr) 
    wantToGoCity = toCity.name

#    if (loopExists(@location, wantToGoCity))
#      another = fromCity.neighbors.select { |loc| loc.name != wantToGoCity }
#      wantToGoCity = another[0].name
#      wantToTakeAveStr = another[0].path
#    end
    
    path = @location + "-" + wantToGoCity
    @visitedPath << path

    puts @name + " heading from " +  @location + " to " + wantToGoCity + " via " + wantToTakeAveStr
    @location = wantToGoCity

  end

  ##############################################################################################################
  # Method updateCounts(loc)
  # update Driver attributes books, dinos, numClasses, or no attribute depending on loc string
  # SUCCESS CASES: update attribute if loc is found
  # FAILURE CASES: does not update anything if loc is not found
  ##############################################################################################################
  def updateCounts(loc)
    if loc == SIM_LOC_MUSEUM
      @dinos  = @dinos + 1
    elsif loc == SIM_LOC_LIBRARY
      @books = @books + 1
    elsif loc == SIM_LOC_LEARNING
      @numClasses = @numClasses * 2
    end
  end
  
  ##############################################################################################################
  # Method summarizeTrip
  # prints out books/toys/classes counts
  ##############################################################################################################
  def summarizeTrip
    puts @name + " obtained " + @books.to_s + (@books != 1? " books!": " book!")
    puts @name + " obtained " + @dinos.to_s + (@dinos != 1? " dinosaur toys!": " dinosaur toy!")
    puts @name + " attended " + @numClasses.to_s + (@numClasses != 1? " classes!": " class!")
  end

  ##############################################################################################################
  # Method loopExists
  # checks if a loop is detected. For example, Hospital to Hillman and Hillman to Hospital
  # SUCCESS CASES: true if loop is detected, false otherwise
  ##############################################################################################################  
    
  def loopExists (city1, city2)
    path1 = city1 + "-" + city2
    path2 = city2 + "-" + city1
    loop1 = city1 + "<->" + city2
    
    found1 = @visitedPath.find { |name| name == path1 }
    found2 = @visitedPath.find { |name| name == path1 }
    loopfound1 = @visitedLoop.find { |name| name == loop1 }
      
    if (found1 != nil && found2 != nil && loopfound1 != nil)
      true
    elsif (found1 != nil && found2 != nil)
      @visitedLoop << loop1
      false
    else
      false
    end
  end 
 
  attr_reader :name 
  attr_reader :location 
  attr_reader :dinos   
  attr_reader :books 
  attr_reader :numClasses   
end