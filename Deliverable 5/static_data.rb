# Class StaticData
# It maintains static data used for the Fun City Traversal Simulatione
class StaticData
  FUN_END = { 'Monroeville' => true, 'Downtown' => true }.freeze
  FUN_CITY_LOCS = %w[Hospital Cathedral Museum Hillman].freeze
  CITY_MAP = { 'Hospital' => [['Cathedral', 'Fourth Ave'], ['Hillman', 'Foo St']],
               'Cathedral' => [['Museum', 'Bar St'], ['Monroeville', 'Fourth Ave']],
               'Museum' => [['Cathedral', 'Bar St'], ['Hillman', 'Fifth Ave']],
               'Hillman' => [['Hospital', 'Foo St'], ['Downtown', 'Fifth Ave']] }.freeze
  FUN_FIVE_DRIVERS = ['Driver 1', 'Driver 2', 'Driver 3', 'Driver 4', 'Driver 5'].freeze
end
