require 'uri'

module TapsPlugin # :nodoc:
  class DatabaseConfig < Hash
    class << self
      def parse_database_yml
        return "" unless File.exists?(Dir.pwd + '/config/database.yml')
        return DatabaseConfig.parse(File.read(Dir.pwd + '/config/database.yml'))
      end 
      def parse(config_file, env = nil)
        environment = env || ENV['RAILS_ENV'] || ENV['MERB_ENV'] || ENV['RACK_ENV']
        environment = 'development' if environment.nil? or environment.empty?

        conf = YAML.load(config_file)
        return new(conf[environment])
      rescue Exception => ex
        puts "Error parsing database.yml: #{ex.message}"
        puts ex.backtrace
        ""
      end
    end
    
    def initialize(conf)
      merge! conf
    end
    
    def to_url
      URI::Generic.build(self.to_uri_hash).to_s
    end
    
    def to_uri_hash
      {
        :scheme => scheme,
        :username => username,
        :password => password,
        :userinfo => userinfo,
        :host => host,
        :port => port,
        :path => path,
        :query => query,
      }
    end
    
    private
    def scheme
      case self['adapter']
      when 'postgresql'
        'postgres'
      when 'sqlite3'
        'sqlite'
      else
        self['adapter']
      end
    end
    
    def username
      self['user'] || self['username']
    end
    
    def password
      self['password']
    end
    
    def userinfo
      if username.blank?
        nil
      else
        userinfo  = ""
        userinfo << username
        userinfo << ":" << password unless password.blank?
        userinfo
      end
    end
    
    def host
      host = self['host'] || self['hostname']
      host ||= '127.0.0.1' unless scheme == 'sqlite'
      host
    end
    
    def port
      self['port']
    end
    
    def path
      if scheme == 'sqlite'
        "//#{self['database']}"
      else
        "/#{self['database']}"
      end
    end
    
    def query
      "encoding=#{normalize_encoding(self['encoding'])}" unless scheme == 'sqlite'
    end
    
    def normalize_encoding(encoding)
      case encoding
      when nil
        'utf8'
      when 'unicode'
        'utf8'
      else
        encoding
      end
    end
  end
end
