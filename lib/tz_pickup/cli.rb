require 'thor'
require 'colorize'

module TzPickup
  class CLI < Thor

    DOWNLOAD_URL = 'ftp://ftp.iana.org/tz/tzdata-latest.tar.gz'

    no_commands do
      def download
        dst = File.join(TzPickup.root, TzPickup::TzTree::DB_PATH)
        file = DOWNLOAD_URL.split('/')[-1]
        cmd = "wget -q #{ DOWNLOAD_URL } -P #{ dst } -O #{ file }"

        if system( cmd )
          puts "#{ file } downloaded successfully and saved to #{ dst }".green
        else
          puts "#{ file } failed to be downloaded from #{ DOWNLOAD_URL } and  saved to #{ dst }".red
        end
      end 
      def unpack
        dst = File.join(TzPickup.root, TzPickup::TzTree::DB_PATH)
        file = DOWNLOAD_URL.split('/')[-1]
        cmd = "wget -q #{ DOWNLOAD_URL } -P #{ dst } -O #{ file }"

        if system( cmd )
          puts "#{ file } downloaded successfully and saved to #{ dst }".green
        else
          puts "#{ file } failed to be downloaded from #{ DOWNLOAD_URL } and  saved to #{ dst }".red
        end
      end 
    end

    desc "charge", "Charge the latest tzdata file from #{ DOWNLOAD_URL }"
    def charge
      download
    end
  end
end