lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'project_monitor_stat'

Gem::Specification.new do |s|
  s.name        = 'project_monitor_stat'
  s.version     = ProjectMonitorStat::VERSION
  s.date        = '2015-06-20'
  s.executables = ['project_monitor_stat']
  s.summary     = 'Ping Project Monitor for your build status'
  s.description = 'A command line until to fetch your build status from project monitor and return the response as your exit code'
  s.authors     = ['Micah Young']
  s.email       = 'micah@young.io'
  s.files       = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md)
  s.require_path = 'lib'
  s.homepage    =
      'http://rubygems.org/gems/project_monitor_stat'
  s.license       = 'MIT'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'sinatra', '~> 1.4'
  s.add_development_dependency 'sinatra-contrib', '~> 1.4'
end
