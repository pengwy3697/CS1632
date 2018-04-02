# Class StaticData
# It maintains all cities
class StaticData
  # This method initializes the static data used for the Fun City Traversal Simulation
  def initialize
    # :nocov:
    @destination = { 'Monroeville' => true, 'Downtown' => true }
    @all_cities = %w[Hospital Cathedral Museum Hillman]
    @city_hash = { 'Hospital' => [['Cathedral', 'Fourth Ave'], ['Hillman', 'Foo St']],
                   'Cathedral' => [['Museum', 'Bar St'], ['Monroeville', 'Fourth Ave']],
                   'Museum' => [['Cathedral', 'Bar St'], ['Hillman', 'Fifth Ave']],
                   'Hillman' => [['Hospital', 'Foo St'], ['Downtown', 'Fifth Ave']] }
    @fun_five_drivers = ['Driver 1', 'Driver 2', 'Driver 3', 'Driver 4', 'Driver 5']
    # :nocov:
  end

  attr_reader :all_cities, :city_hash, :destination, :fun_five_drivers

  private

  attr_writer :all_cities, :city_hash, :destination, :fun_five_drivers
end
