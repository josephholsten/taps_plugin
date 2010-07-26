require File.dirname(__FILE__) + '/test_helper'
require 'rails/generators'
require 'generators/taps/taps_generator'

class TapsGeneratorTest < Rails::Generators::TestCase
  tests TapsGenerator
  destination File.join(File.dirname(__FILE__), "rails_root")
  
  setup :prepare_destination, :prepare_gemfile

  def test_generates_script
    run_generator
    assert_file "script/taps_server"
  end
  
  def test_adds_taps_dependency
    run_generator
    assert_file 'Gemfile', /gem "taps", "~>0.3", :group => "development"/
  end
  
  protected
  def prepare_gemfile
    action :create_file, 'Gemfile'
  end
  
  def action(*args, &block)
    silence(:stdout){ generator.send(*args, &block) }
  end
  
end