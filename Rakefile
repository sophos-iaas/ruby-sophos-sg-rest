require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new(:spec)

desc "Run specs on jenkins"
RSpec::Core::RakeTask.new(:jenkins) do |t|
  t.rspec_opts = '--format RspecJunitFormatter --out rspec.xml'
end
