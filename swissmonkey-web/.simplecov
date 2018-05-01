SimpleCov.minimum_coverage 65
SimpleCov.minimum_coverage_by_file 0

SimpleCov.start 'rails' do
  add_filter "/app/admin/"
  add_filter "/app/channels/"
end