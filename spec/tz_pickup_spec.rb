# 2.  Latitude and longitude of the zone's principal location
#     in ISO 6709 sign-degrees-minutes-seconds format,
#     either +-DDMM+-DDDMM or +-DDMMSS+-DDDMMSS,
#     first latitude (+ is north), then longitude (+ is east).
# 3.  Zone name used in value of TZ environment variable.

=begin
VI  +1821-06456 America/St_Thomas
VN  +1045+10640 Asia/Ho_Chi_Minh
VU  -1740+16825 Pacific/Efate
WF  -1318-17610 Pacific/Wallis
WS  -1350-17144 Pacific/Apia
YE  +1245+04512 Asia/Aden
YT  -1247+04514 Indian/Mayotte
ZA  -2615+02800 Africa/Johannesburg
ZM  -1525+02817 Africa/Lusaka
ZW  -1750+03103 Africa/Harare
=end
require 'tz_pickup'
require 'mocha/api'

describe TzPickup do
  it "should return the nearest time zone for specified lon and lat" do
    TzPickup.tz_pickup(-124800, 0451500).should eql 'Indian/Mayotte'
  end

  it "should return root path for current env" do
    TzPickup.root.should eql File.expand_path('../spec')

    Rails = mock('Rails')
    Rails.expects(:root).returns('correct rails root path').at_least_once

    TzPickup.root.should eql 'correct rails root path'
  end
end

describe TzPickup::TzTree do
  before(:all) do
    @src = File.join('spec', TzPickup::TzTree::DB_PATH, TzPickup::TzTree::ZONE_FILE)
    @dst = File.join('spec', TzPickup::TzTree::DB_PATH, TzPickup::TzTree::TREE_FILE)
    @path = File.expand_path('spec')
  end

  it "should return TzTree object for zone.tab under current root path" do
    tree_object = TzPickup::TzTree.get_tree(@path)

    tree_object.should respond_to(:find_tz)
  end

  it "should parse line of text with location specified by +-DDMM+-DDDMM to list [latitude, longitude, timezone]" do
    line = "VI  +1821-06456 America/St_Thomas"

    TzPickup::TzTree.parse_line(line).should eql [182100, -0645600, 'America/St_Thomas']
  end

  it "should parse line of text with location specified by +-DDMMSS+-DDDMMSS to list [latitude, longitude, timezone]" do
    line = "US +211825-1575130 Pacific/Honolulu  Hawaii"

    TzPickup::TzTree.parse_line(line).should eql [211825, -1575130, 'Pacific/Honolulu']
  end

  it "should raise an exception on parsing incorrect line of text" do
    line = "US 000000-121212121212 some_incorrect_data"

    lambda { TzPickup::TzTree.parse_line(line) }.should raise_error(ArgumentError)
  end

  it "should create Kdtree file from zone-file" do
    File.delete(@dst) if File.exists?(@dst)
    tree = TzPickup::TzTree.new(@path).send(:create, @src, @dst)

    tree.should respond_to(:nearest)
    File.exists?(dst_path).should be true
  end

  it "should raise error if zone-file is unavailable" do   
    lambda { TzPickup::TzTree.new(@path).send(:create, 'incorrect/file/name', @dst) }.should raise_error(ArgumentError)
  end

  it "should load Kdtree from zone-file" do
    TzPickup::TzTree.new(@path).send(:create, @src, @dst)
    tree = TzPickup::TzTree.new(@path).send(:load, @dst)

    tree.should respond_to(:nearest)
  end

  it "should raise error if tree-file is unavailable" do
    lambda { TzPickup::TzTree.new(@path).send(:load, 'incorrect/file/name') }.should raise_error(ArgumentError)
  end

  it "should find timezone by given lat and lon" do
    TzPickup::TzTree.new(@path).find_tz(+182100, -0645600).should eql 'America/St_Thomas'
  end
end
