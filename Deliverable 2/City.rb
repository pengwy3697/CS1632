
##############################################################################################################
# Class City
#       It maintains the city name and an array of its neighboring cities (name and street/avenue pairs)
##############################################################################################################

class City
  def initialize (name = "")
    @name = name
    @neighbors = []
  end
  
  def addNeighbor (name, path)
    @neighbors << Neighbor.new(name, path)
  end
  
  def printNeighbors
    @neighbors.each { |x| puts "    " + x.name }
  end
  
  attr_reader :name
  attr_reader :neighbors
end