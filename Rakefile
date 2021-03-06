require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  require 'bundler'
  Jeweler::Tasks.new do |gem|
    gem.name = "forest"
    gem.summary = %Q{A simple collection class to aggregate tree objects}
    gem.description = %Q{A simple collection class to aggregate tree objects.
    It takes [Adjacency List](http://sqlsummit.com/AdjacencyList.htm) as input, shows some stats and the top x biggest trees.}
    gem.homepage = "http://github.com/makoto/forest"
    gem.authors = ["Makoto Inoue"]
    gem.add_bundler_dependencies
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "forest #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
