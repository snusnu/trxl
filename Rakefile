require 'rubygems'
require 'rake'

begin

  gem 'jeweler', '>= 1.4'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|

    gem.name        = "trxl"
    gem.summary     = 'A specced little language written with ruby and treetop.'
    gem.description = 'A specced little language written with ruby and treetop. It has lambdas, recursion, conditionals, arrays, hashes, ranges, strings, arithmetics and some other stuff. It even has a small code import facility.'
    gem.email       = "gamsnjaga [at] gmail [dot] com"
    gem.homepage    = "http://github.com/snusnu/trxl"
    gem.authors     = ['Martin Gamsjaeger (snusnu)', 'Michael Aufreiter']

    # Runtime dependencies
    gem.add_dependency 'treetop', '>= 1.4'

    # Development dependencies
    gem.add_development_dependency 'rspec', '>= 1.2.9'

  end

  Jeweler::GemcutterTasks.new

rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.pattern    = 'spec/**/*_spec.rb'
  spec.libs      << 'lib' << 'spec'
  spec.spec_opts << '--options' << 'spec/spec.opts'
end

task :default => :spec


