
##############################################################################################################
# Class Neighbor
#       It maintains the city name and the inbounding street/avenue 
##############################################################################################################

class Neighbor 
  def initialize (name, path)
    @name = name
    @path = path
  end
  
  attr_reader :name
  attr_reader :path
end