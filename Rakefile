require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "orderly_garden"

OrderlyGarden.init!

RSpec::Core::RakeTask.new(:spec)

task default: :spec

INVALID_CONVERSIONS = { complex: %i(json) }.freeze

desc "Update binary/JSON fixtures from XML versions, then canonicalize the XML versions."
task :update_fixtures do
  # TODO: Bail if XML versions are dirty so we can't accidentally destroy work on them.
  cd "spec/fixtures" do
    %i(simple complex).each do |sample|
      # Update JSON/binary versions using the XML version as authoritative:
      %i(json binary1).each do |format|
        next if INVALID_CONVERSIONS[sample] && INVALID_CONVERSIONS[sample].include?(format)
        sh "plutil -convert #{format} #{sample}_xml1.plist -o #{sample}_#{format}.plist "
      end
      # ... and make sure our formatting is consistent here:
      sh "plutil -convert xml1 #{sample}_binary1.plist -o #{sample}_xml1.plist "
    end
  end
end
