Gem::Specification.new do |s|
  s.name        = 'codility_log'
  s.version     = '0.0.1'
  s.date        = '2018-12-18'
  s.summary     = "Codility logging helper"
  s.description = "Helper class for logging to the terminal"
  s.authors     = ["Kordian Cichowski"]
  s.email       = 'sysadm@codility.com'
  s.files       = ['lib/codility_log.rb']
  s.add_runtime_dependency 'highline', '~> 1.7'
end
