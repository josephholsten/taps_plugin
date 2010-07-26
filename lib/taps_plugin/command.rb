module TapsPlugin
  class Command
    def self.start(argv)
      subcommand = argv.shift
      case subcommand
      when 'pull'
        TapsPlugin::Pull::Command.start(argv)
      when 'server'
        TapsPlugin::Server::Command.start(argv)
      else
        abort  <<EOHELP
Options
=======
server    Start a taps database import/export server
pull      Pull a database from a taps server

EOHELP
      end
    end
  end
end
