require 'thor'
require 'colorize'

module TzPickup
  class CLI < Thor

    DOWNLOAD_URL = 'ftp://ftp.iana.org/tz/tzdata-latest.tar.gz'

    def initialize(*args)
      super

      @file = DOWNLOAD_URL.split('/')[-1]
      @dst_dir = File.join(TzPickup.root, TzPickup::TzTree::DB_PATH)
      @dst_file = File.join(@dst_dir, @file)
    end

    no_commands do
      def download  
        cmd = "wget -q #{ DOWNLOAD_URL } -O #{ @dst_file }"

        if system( cmd )
          puts "#{ @file } downloaded successfully and saved to #{ @dst_file }".green
        else
          puts "#{ @file } failed to be downloaded from #{ DOWNLOAD_URL } and saved to #{ @dst_file }".red
        end
      end 

      def unpack
        #tar zxf spec/db/tzdata-latest.tar.gz -C spec/db/ zone.tab

        cmd = "tar zxf #{ @dst_file } -C #{ @dst_dir } #{ TzPickup::TzTree::ZONE_FILE }"

        if system( cmd )
          puts "#{ TzPickup::TzTree::ZONE_FILE } successfully extracted to #{ @dst_dir }".green
        else
          puts "#{ TzPickup::TzTree::ZONE_FILE } failed to be extracted from #{ @dst_file } to #{ @dst_dir }".red
        end
      end 

      def remove
        cmd = "rm #{ @dst_file }"

        if system( cmd )
          puts "#{ @dst_file } removed successfully".green
        else
          puts "#{ @dst_file } failed to be removed".red
        end
      end
    end

    desc "charge", "Charge the latest tzdata file from #{ DOWNLOAD_URL }"
    def charge
      download
      unpack
      remove
    end
  end
end