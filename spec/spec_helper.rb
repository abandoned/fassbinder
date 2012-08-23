require File.expand_path(File.dirname(__FILE__) + '/../lib/fassbinder')
require 'vcr'

VCR.configuration do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :typhoeus
  config.configure_rspec_meta_data!
  config.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.run_all_when_everything_filtered = true
  c.filter_run :focus
end
