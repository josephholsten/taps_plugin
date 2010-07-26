require 'taps_plugin/database_config'

module TapsPlugin # :nodoc:
module Server # :nodoc:
  class Command
    class Options
      def self.parse!(argv)
        require 'optparse'
        opts={:port => 5000, :login => nil, :password => nil, :debug => false}
        OptionParser.new do |o|
          o.banner = "Usage: #{File.basename($0)} [OPTIONS] <login> <password>"
          o.define_head "Start a taps database import/export server"

          o.on("-p", "--port=N", "Server Port") { |v| opts[:port] = v.to_i if v.to_i > 0 }

          o.on("-d", "--debug", "Enable Debug Messages") { |v| opts[:debug] = true }

          o.parse!(argv)

          opts[:login] = argv.shift
          opts[:password] = argv.shift

          if opts[:login].nil?
            $stderr.puts "Missing Login"
            puts o
            exit 1
          end
          if opts[:password].nil?
            $stderr.puts "Missing Password"
            puts o
            exit 1
          end
        end
        opts
      end
    end

    def self.start(args)
      require 'taps/operation'
      require 'taps/cli'
      opts = Options.parse!(args)
      Taps.log.level = Logger::DEBUG if opts[:debug]
      Taps::Config.database_url = DatabaseConfig.parse_database_yml.to_url
      Taps::Config.login = opts[:login]
      Taps::Config.password = opts[:password]

      Taps::Config.verify_database_url

      require 'taps/server'
      puts "Playing Taps v#{Taps.version} on #{Taps::Config.database_url}"
      Taps::Server.run!({
        :port => opts[:port],
        :environment => :production,
        :logging => true,
        :dump_errors => true,
      })
    end
  end
end
end
