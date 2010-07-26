require 'test_helper'
require 'taps_plugin'
require 'rr'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

class CommandTest < ActiveSupport::TestCase
  test "handles pull" do
    mock(TapsPlugin::Pull::Command).start(%w{foo bar})
    
    TapsPlugin::Command.start(%w{pull foo bar})
  end
  
  test "handles server" do
    mock(TapsPlugin::Server::Command).start(%w{foo bar})
    
    TapsPlugin::Command.start(%w{server foo bar})
  end
end
