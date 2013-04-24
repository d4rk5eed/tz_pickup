require "tz_pickup/version"
require "tz_pickup/cli"
require "tz_pickup/tz_tree"
require "kdtree"

module TzPickup
  ##
  # Method return proper root path
  # either for rails environment 
  # or for tests
  #
  # Input: none
  # Output: root path
  def self.root 
    (defined?(Rails) && !Rails.root.nil?) ? Rails.root : File.expand_path('../spec', File.dirname(__FILE__))
  end

  ##
  # Method returns timezone
  # based on location 
  # that is the nearest to +lat+ and +lon+
  #
  # Input: latitude and longitude
  # Output: international timezone name
  def self.tz_pickup(lat, lon)
    tree = TzTree.get_tree(root)
    tree.find_tz(lat, lon)
  end
end
