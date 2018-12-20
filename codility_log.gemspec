Gem::Specification.new do |s|
  s.name        = 'codility_log'
  s.version     = '0.0.2'
  s.summary     = "Codility logging helper"
  s.description = "Helper class for logging to the terminal"
  s.authors     = ["Kordian Cichowski"]
  s.email       = 'kordian@codility.com'
  s.files       = ['lib/codility_log.rb']
  s.homepage    = 'https://codility.com'
  s.licenses    = ['MIT']
  s.add_runtime_dependency 'highline', '~> 1.7'
  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/codility/codility_log",
    "homepage_uri"      => "https://github.com/codility/codility_log",
    "source_code_uri"   => "https://github.com/codility/codility_log",
  }
end
