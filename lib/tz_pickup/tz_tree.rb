module TzPickup  
  class TzTree
    DB_PATH = 'db'
    ZONE_FILE = 'zone.tab'
    TREE_FILE = 'zone.tree'  
    CITY_FILE = 'zone.cities'  

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
    #
    # Input: line of text
    # Output: list of longitude, latitude 
    # and timezone name
    def self.parse_line(line)
      return nil if line =~ /^\s*#/ #drop off comments

      rx = %r|[A-Z]{2}\s+(?<latitude>[+\-]\d{4}(?:\d{2})?)(?<longitude>[+\-]\d{5}(?:\d{2})?)\s+(?<timezone>[\w/]+)|
      matches = line.match(rx)
      
      raise ArgumentError, "String should match tz database format (https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)" unless matches

      [normalize(matches[:latitude]), normalize(matches[:longitude]), matches[:timezone]]
    end

    def self.normalize(num)
      return num.to_i * 100 if num =~ /^[+\-]\d{4}\d?$/
      num.to_i
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
      @tree, @cities = if File.exists?(tree_dst_path) && File.exists?(city_dst_path)
        TzPickup::TzTree.load(tree_dst_path, city_dst_path)
      else
        TzPickup::TzTree.create(src_path, tree_dst_path, city_dst_path)
      end
    end

    def src_path
      File.join(@path, TzPickup::TzTree::DB_PATH, TzPickup::TzTree::ZONE_FILE)
    end

    def tree_dst_path
      File.join(@path, TzPickup::TzTree::DB_PATH, TzPickup::TzTree::TREE_FILE)
    end

    def city_dst_path
      File.join(@path, TzPickup::TzTree::DB_PATH, TzPickup::TzTree::CITY_FILE)
    end

    ##
    # Method finds to the nearest dot
    # to the dot specified by +lat+ and +lon+
    #
    # Input: latitude and longitude
    # Output: conventional timezone name
    def find_tz(lat, lon)
      city_index = @tree.nearest(lat, lon)
      @cities.at(city_index)
    end

    ##
    # Method creates tree structure from +src+ zone-file
    # and dumps tree to +tree_dst+ file
    # and dumps cities list to +city_dst+
    #
    # It raises exception on error of file reading 
    #
    # Input: name of source zone-file, 
    # name of destination tree file, 
    # name of destination cities file,
    # Output: list of tree structure for time-zones and cities list 
    def self.create(src, tree_dst, city_dst)
      points = []
      cities = []

      File.open(src, 'r').each do |line|
        timezone = TzPickup::TzTree.parse_line(line)
        
        next unless timezone

        cities << timezone[2]
        points << [timezone[0], timezone[1], (cities.size - 1)]
      end

      tree = Kdtree.new(points)

      File.open(tree_dst, 'w') { |f| tree.persist(f) }
      File.open(city_dst, 'w') { |f| f.puts cities }
      
      [tree, cities]
    end

    ##
    # Method loads tree structure
    # from existing +zone_file+
    # and existiong +city_file+
    #
    # Input: name of zone tree file
    # and name of cities file
    # Output: tree structure for time-zones
    # and city list
    def self.load(zone_file, city_file)
      cities = []

      tree = File.open(zone_file) { |f| Kdtree.new(f) }

      File.open(city_file, 'r').each do |line|
        cities << line.chomp
      end

      [tree, cities]
    end
  end
end