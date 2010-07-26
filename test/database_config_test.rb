require 'test_helper'
require 'taps_plugin'

class TapsPlugin::DatabaseConfigTest < ActiveSupport::TestCase
  test "defaults host to 127.0.0.1 with a username" do
    db = TapsPlugin::DatabaseConfig.new('adapter' => 'db', 'username' => 'user', 'database' => 'database')
    assert_equal 'db://user@127.0.0.1/database?encoding=utf8', db.to_url
  end

  test "handles the lack of a username properly" do
    db = TapsPlugin::DatabaseConfig.new('adapter' => 'db', 'database' => 'database')
    assert_equal 'db://127.0.0.1/database?encoding=utf8', db.to_url
  end

  test "handles integer port number" do
    db = TapsPlugin::DatabaseConfig.new({'adapter' => 'db', 'database' => 'database', 'port' => 9000})
    assert_equal 'db://127.0.0.1:9000/database?encoding=utf8', db.to_url
  end

  test "correct scheme from postgres adapter" do
    db = TapsPlugin::DatabaseConfig.new('adapter' => 'postgresql', 'database' => 'database', 'port' => 9000)
    assert_match %r{postgres://}, db.to_url
  end
  
  test "sqlite scheme and path" do
    db = TapsPlugin::DatabaseConfig.new('adapter' => 'sqlite3', 'database' => 'db/database.db')
    assert_match %r{sqlite://db/database.db}, db.to_url
  end

  test "correct encoding from unicode" do
    db = TapsPlugin::DatabaseConfig.new('adapter' => 'db', 'database' => 'database', 'encoding' => 'unicode')
    assert_match %r{\?encoding=utf8}, db.to_url
  end

  test "default encoding" do
    db = TapsPlugin::DatabaseConfig.new('adapter' => 'db', 'database' => 'database')
    assert_match %r{\?encoding=utf8}, db.to_url
  end
end
