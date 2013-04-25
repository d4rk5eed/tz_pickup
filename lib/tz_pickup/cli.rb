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

      @commands = [
        {
          cmd: "mkdir -p #{ @dst_dir }",
          success: "1. Using #{ @dst_dir }",
          error: "1. Failed to use #{ @dst_dir }"          
        },
        {
          cmd: "wget -q #{ DOWNLOAD_URL } -O #{ @dst_file }",
          success: "2. #{ @file } downloaded successfully and saved to #{ @dst_file }",
          error: "2. #{ @file } failed to be downloaded from #{ DOWNLOAD_URL } and saved to #{ @dst_file }"          
        },
        {
          cmd: "tar zxf #{ @dst_file } -C #{ @dst_dir } #{ TzPickup::TzTree::ZONE_FILE }",
          success: "3. #{ TzPickup::TzTree::ZONE_FILE } successfully extracted to #{ @dst_dir }",
          error: "3. #{ TzPickup::TzTree::ZONE_FILE } failed to be extracted from #{ @dst_file } to #{ @dst_dir }"          
        }
      ]

      @ensure_block = {
        cmd: "rm -f #{ @dst_file }",
        success: "4. #{ @dst_file } removed successfully",
        error: "4. #{ @dst_file } failed to be removed" 
      }
    end

    no_commands do
      def execute(command)
        if system(command[:cmd])
          puts command[:success].green
        else
          puts command[:error].red
          raise SystemCallError.new(command[:error], $?.to_i)
        end
      end
    end

    desc "charge", "Charge the latest tzdata file from #{ DOWNLOAD_URL }"
    def charge
      begin
        @commands.each { |cmd| execute cmd }
      rescue SystemCallError => error
        puts "Errno: #{ error.errno }"
      ensure
        execute @ensure_block
      end
    end
  end
end
