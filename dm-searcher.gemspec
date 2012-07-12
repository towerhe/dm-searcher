# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dm-searcher/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tower He"]
  gem.email         = ["towerhe@gmail.com"]
  gem.description   = %q{DataMapper plugin providing for searching models with nested conditions.}
  gem.summary       = %q{DataMapper plugin providing for searching models with nested conditions.}
  gem.homepage      = "https://github.com/dm-searcher"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dm-searcher"
  gem.require_paths = ["lib"]
  gem.version       = Dm::Searcher::VERSION

  gem.add_dependency 'data_mapper', '~> 1.2'
end
