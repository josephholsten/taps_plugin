require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/clean'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the taps_server plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the taps_server plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'TapsServer'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

CLEAN.include %w{ Gemfile.lock test/rails_root .bundle }