require "tz_pickup/version"

module TzPickup

  class TzTree
    DB_PATH = 'db'
    ZONE_FILE = 'zone.tab'
    TREE_FILE = 'zone.tree'  

    ##
    # Method creates object of TzTree 
    # that is based on zone-file located
    # under +path+ directory
    #
    # Input: root-path for working directory
    # Output: TzTree object   
    def self.get_tree(path)
      TzPickup::TzTree.new(path)
    end

    ##
    # Method parses +line+ of text
    # to list of three params
    # Input: line of text
    # Output: list of longitude, latitude 
    # and timezone name
    def self.parse_line(line)
    end

    ##
    # Constructor that search for tree-file under +path+
    # and either loads tree to memory 
    # or creates file and loads its contents to memory
    #
    # Input: root-path for working directory
    # Output: TzTree object
    def initialize(path)
      @path = path
      @tree = if File.exists?(dst_path)
        load(dst_path)
      else
        create(src_path, dst_path)
      end
    end

    def src_path
      File.join(@path, TzPickup::TzTree::DB_PATH, TzPickup::TzTree::ZONE_FILE)
    end

    def dst_path
      File.join(@path, TzPickup::TzTree::DB_PATH, TzPickup::TzTree::TREE_FILE)
    end

    ##
    # Method finds to the nearest dot
    # to the dot specified by +lat+ and +lon+
    #
    # Input: latitude and longitude
    # Output: conventional timezone name
    def find_tz(lat, lon)
      @tree.nearest(lat, lon)
    end

    private
    ##
    # Method creates tree structure from +src+ zone-file
    # and dumps it to +dst+ file
    #
    # It raises exception on error of file reading 
    #
    # Input: name of source zone-file, 
    # name of destination tree file
    # Output: tree structure for time-zones
    def create(src, dst)

    end

    ##
    # Method loads tree structure
    # from existing +file+
    #
    # Input: name of source tree file
    # Output: tree structure for time-zones
    def load(file)
    end
  end


  ##
  # Method return proper root path
  # either for rails environment 
  # or for tests
  #
  # Input: none
  # Output: root path
  def self.root 
    (defined?(Rails) && !Rails.root.nil?) ? Rails.root : File.expand_path('../spec')
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
    tree.find_tz(lon, lat)
  end
end
