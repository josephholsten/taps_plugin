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
  begin
    require 'sdoc'
  rescue LoadError
    warn "sdoc could not be loaded. Using ugly rdoc templates instead."
  end
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Taps Plugin'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

CLEAN.include %w{ Gemfile.lock test/rails_root .bundle rdoc }
