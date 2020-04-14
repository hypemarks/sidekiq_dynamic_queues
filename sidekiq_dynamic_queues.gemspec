# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'sidekiq/dynamic_queues/version'

Gem::Specification.new do |s|
  s.name = 'sidekiq_dynamic_queues'
  s.version = Sidekiq::DynamicQueues::VERSION
  s.authors = ['Francois Deschenes']
  s.email = ['fdeschenes@me.com']
  s.description = ''
  s.summary = ''
  s.homepage = 'https://github.com/hypemarks/sidekiq_dynamic_queues'
  s.license = 'MIT'

  s.files = Dir['LICENSE', 'README.md', 'lib/**/*', 'web/**/*']
  s.test_files = Dir['spec/**/*']
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.3'

  s.add_dependency 'sidekiq', '< 6'
end
