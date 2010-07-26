require 'taps_plugin/database_config'

module TapsPlugin # :nodoc:
module Pull # :nodoc:
  class Command
    class Options
      def self.parse!(argv)
    		opts={:default_chunksize => 1000, :database_url => nil, :remote_url => nil, :debug => false, :resume_filename => nil, :disable_compresion => false, :indexes_first => false}
    		OptionParser.new do |o|
    			o.banner = "Usage: #{File.basename($0)} [OPTIONS] <remote_url>"

  				o.define_head "Pull a database from a taps server"

    			o.on("-i", "--indexes-first", "Transfer indexes first before data") { |v| opts[:indexes_first] = true }
    			o.on("-r", "--resume=file", "Resume a Taps Session from a stored file") { |v| opts[:resume_filename] = v }
    			o.on("-c", "--chunksize=N", "Initial Chunksize") { |v| opts[:default_chunksize] = (v.to_i < 10 ? 10 : v.to_i) }
    			o.on("-g", "--disable-compression", "Disable Compression") { |v| opts[:disable_compression] = true }
    			o.on("-f", "--filter=regex", "Regex Filter for tables") { |v| opts[:table_filter] = v }
    			o.on("-t", "--tables=A,B,C", Array, "Shortcut to filter on a list of tables") do |v|
    				r_tables = v.collect { |t| "^#{t}$" }.join("|")
    				opts[:table_filter] = "(#{r_tables})"
    			end
    			o.on("-d", "--debug", "Enable Debug Messages") { |v| opts[:debug] = true }
    			o.parse!(argv)

    			opts[:remote_url] = argv.shift

    			if opts[:remote_url].nil?
    				$stderr.puts "Missing Remote Taps URL"
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
  		
  		database_url =  DatabaseConfig.parse_database_yml.to_url
  		Taps::Config.verify_database_url(database_url)
  		
  		remote_url = opts.delete(:remote_url)
  		if opts[:resume_filename]
    		session = JSON.parse(File.read(opts.delete(:resume_filename)))
    		session.symbolize_recursively!

    		remote_url ||= session.delete(:remote_url)

    		opts = session.merge({
    			:default_chunksize => opts[:default_chunksize],
    			:disable_compression => opts[:disable_compression],
    			:resume => true,
    		})
  		end  
  		Taps::Operation.factory(:pull, database_url, remote_url, opts).run
    end
  end
end
end
