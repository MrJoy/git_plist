require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "orderly_garden"

OrderlyGarden.init!

RSpec::Core::RakeTask.new(:spec)

task default: :spec
